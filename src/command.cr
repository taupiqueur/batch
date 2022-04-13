record(Command, command : String, args : Enumerable(String) = [] of String, shell : Bool = false) do
  def self.parse(shell_command : String) : self
    command, *args = Process.parse_arguments(shell_command)
    new(command, args)
  end

  def quote : String
    Process.quote([command, *args])
  end

  def add_arg(value : String) : self
    Command.new(command, [*args, value])
  end
end
