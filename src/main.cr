require "option_parser"
require "ecr/macros"

require "./env"
require "./command"

VERSION = {{ `git describe --tags --always`.chomp.stringify }}

pick_command = Command.new("echo")
map_command = Command.new("echo")
drop_command = Command.new("echo")
editor_command = Command.parse(ENV["EDITOR"])
filter_commands = Array(Command).new
edit = true
pick = true
map = true
drop = true
read_stdin = false
tempfiles = Set(File).new

# Register an `at_exit` handler to clean up temporary files.
at_exit { tempfiles.each(&.delete) }

def handle_command(command : Command)
  status = Process.run(command.command, command.args, input: :inherit, output: :inherit, error: :inherit)
  abort "ERROR: #{command.command} exited with: #{status.exit_code}." unless status.success?
rescue exception
  abort "ERROR: Running command '#{command.command}': #{exception.message}."
end

OptionParser.parse do |parser|
  parser.banner = "Usage: batch [switches] [--] [arguments]"
  parser.on("-p COMMAND", "--pick-command=COMMAND", "Specifies the command to run on unchanged items") { |shell_command| pick_command = Command.parse(shell_command) }
  parser.on("-m COMMAND", "--map-command=COMMAND", "Specifies the command to run on modified items") { |shell_command| map_command = Command.parse(shell_command) }
  parser.on("-d COMMAND", "--drop-command=COMMAND", "Specifies the command to run on deleted items") { |shell_command| drop_command = Command.parse(shell_command) }
  parser.on("-P COMMAND", "--pick-shell-script=COMMAND", "Specifies the shell script to run on unchanged items") { |shell_command| pick_command = Command.new(shell_command, shell: true) }
  parser.on("-M COMMAND", "--map-shell-script=COMMAND", "Specifies the shell script to run on modified items") { |shell_command| map_command = Command.new(shell_command, shell: true) }
  parser.on("-D COMMAND", "--drop-shell-script=COMMAND", "Specifies the shell script to run on deleted items") { |shell_command| drop_command = Command.new(shell_command, shell: true) }
  parser.on("-e COMMAND", "--editor=COMMAND", "Specifies the editor to use") { |shell_command| editor_command = Command.parse(shell_command) }
  parser.on("-f COMMAND", "--filter=COMMAND", "Adds a filter (repeatable)") { |shell_command| filter_commands << Command.parse(shell_command) }
  parser.on("-E", "--no-edit", "Do not open editor") { edit = false }
  parser.on("--no-pick", "Do not pick items") { pick = false }
  parser.on("--no-map", "Do not map items") { map = false }
  parser.on("--no-drop", "Do not drop items") { drop = false }
  parser.on("-", "Read items from stdin") do
    read_stdin = true
  end
  parser.on("-h", "--help", "Show this help") do
    puts parser
    exit
  end
  parser.on("-v", "--version", "Show version") do
    puts VERSION
    exit
  end
  parser.missing_option do |flag|
    abort "ERROR: #{flag} is missing something."
  end
  parser.invalid_option do |flag|
    abort "ERROR: #{flag} is not a valid option."
  end
end

# Assemble the list of items from argv.
input_items, invalid_items = ARGV.partition do |arg|
  !arg.includes?('\n')
end

# Sanity check
# Cannot work with multi-line items.
if invalid_items.any?
  abort "ERROR: Cannot work with multi-line items: #{invalid_items}."
end

# Read items from stdin.
# This is the default when no items have been specified from the command-line.
if read_stdin || input_items.empty?
  input_items.concat(STDIN.gets_to_end.lines)
  STDIN.reopen(File.new("/dev/tty"))
end

# Something to do?
# Bails out if there is no items to process.
if input_items.empty?
  abort "ERROR: Nothing to do."
end

# Pipe items to external filters for pre-editing.
editor_input = IO::Memory.new(input_items.join('\n'))
editor_output = filter_commands.reduce(editor_input) do |input, filter|
  Process.new(filter.command, filter.args, input: input, output: :pipe).output
rescue exception
  abort "ERROR: Running external filter '#{filter.command}': #{exception.message}."
end

# Create the editor’s file.
editor_file = File.tempfile("batch", ".txt") do |file|
  IO.copy(editor_output, file)
end
tempfiles << editor_file

# Open text editor.
handle_command(editor_command.add_arg(editor_file.path)) if edit

# Prepare translation.
output_items = File.read_lines(editor_file.path)

# Sanity check
# Cannot operate translation if number of lines differs.
if input_items.size != output_items.size
  abort "ERROR: Cannot operate translation. Number of lines differs."
end

# Group changes.
pick_items = Set(String).new
map_items = Set(Tuple(String, String)).new
drop_items = Set(String).new
grouped_items = input_items.zip(output_items).group_by do |input, output|
  if input == output
    pick_items << input
  elsif output.empty?
    drop_items << input
  else
    map_items << {input, output}
  end
end

# Generate the shell script.
shell_file = File.tempfile("batch", ".sh") do |file|
  ECR.embed("src/template/batch.sh.ecr", file)
end
tempfiles << shell_file

# Confirm execution
# Open the script to review it.
handle_command(editor_command.add_arg(shell_file.path)) if edit

# Do the processing.
handle_command(Command.new("sh", {shell_file.path}))
