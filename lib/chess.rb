# frozen_string_literal: true

require_relative 'chess/app'

# namespace for the project.
module CLIChess
  def self.run(args)
    puts "File: #{__FILE__.split('/')[-1]}, Running method: #{__method__}"
    app = CLIChess::App.new
    app.run(args)
  end
end

# Start the program if this file is executed directly
CLIChess.run(ARGV) if __FILE__ == $0
