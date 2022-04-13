require "spec"

# Runs the binary with the given arguments.
def run_binary(command = "bin/batch", args = [] of String, env = nil, input = "", file = "", edit = false)
  input = IO::Memory.new(input)
  output = IO::Memory.new
  error = IO::Memory.new

  args.unshift("--no-edit") unless edit

  if file.presence
    tmp_file = File.tempfile { |io| io << file }
    at_exit { tmp_file.delete }
    args.unshift("--filter=cat #{tmp_file.path}")
  end

  status = Process.run(command, args, env: env, clear_env: false, input: input, output: output, error: error)

  yield(status, output.to_s, error.to_s)
end

# Runs the binary with the given expectations.
def run_binary(command = "bin/batch", args = [] of String, env = nil, input = "", file = "", edit = false, output expected_output = "", error expected_error = "", success = true, exit_code = success ? 0 : 1)
  run_binary(command, args, env, input, file, edit) do |status, output, error|
    it "exits correctly" do
      status.success?.should eq success
      status.exit_code.should eq exit_code
    end

    it "returns the correct output" do
      output.should eq expected_output
      error.should eq expected_error
    end
  end
end
