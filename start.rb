base_file_path = File.join(File.expand_path(File.dirname(__FILE__)), "simpreter.rb")
require base_file_path

simpreter = Simpreter.new
simpreter.start