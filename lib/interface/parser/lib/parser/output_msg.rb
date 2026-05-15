# frozen_string_literal: true

# project namespace
module CLIChess
  # create a new parser error node
  module OutputMSG
    def output_msg(msg: nil)
      File.open('out.put', 'a') do |file|
        file.puts msg
      end
    end
  end
end
