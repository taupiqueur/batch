#compdef batch

local OPTION_WORDLIST=(
  "-p[Specifies the command to run on unchanged items]:command:_command_names"
  "--pick-command=[Specifies the command to run on unchanged items]:command:_command_names"
  "-m[Specifies the command to run on modified items]:command:_command_names"
  "--map-command=[Specifies the command to run on modified items]:command:_command_names"
  "-d[Specifies the command to run on deleted items]:command:_command_names"
  "--drop-command=[Specifies the command to run on deleted items]:command:_command_names"
  "-P[Specifies the shell script to run on unchanged items]:command:_command_names"
  "--pick-shell-script=[Specifies the shell script to run on unchanged items]:command:_command_names"
  "-M[Specifies the shell script to run on modified items]:command:_command_names"
  "--map-shell-script=[Specifies the shell script to run on modified items]:command:_command_names"
  "-D[Specifies the shell script to run on deleted items]:command:_command_names"
  "--drop-shell-script=[Specifies the shell script to run on deleted items]:command:_command_names"
  "-e[Specifies the editor to use]:command:_command_names"
  "--editor=[Specifies the editor to use]:command:_command_names"
  "*-f[Adds a filter (repeatable)]:command:_command_names"
  "*--filter=[Adds a filter (repeatable)]:command:_command_names"
  "-E[Do not open editor]"
  "--no-edit[Do not open editor]"
  "--no-pick[Do not pick items]"
  "--no-map[Do not map items]"
  "--no-drop[Do not drop items]"
  "-[Read items from stdin]"
  "-h[Show this help]"
  "--help[Show this help]"
  "-V[Show version]"
  "--version[Show version]"
)

_arguments -S -s "${OPTION_WORDLIST[@]}" "*:file:_files"