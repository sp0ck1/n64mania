require 'csv'

def import_jhawk_commands
  table = CSV.parse(File.read("tmp/commands.csv"), headers: true)
  Command.new(command: row["COMMAND"], text: row["TEXT"], author: row["AUTHOR"], created_at: row["CREATED"])
end