# frozen_string_literal: true

require_relative 'chess/constants'
require_relative 'chess/app'
require_relative 'chess/render'
require_relative 'chess/board/board_rank'
require_relative 'chess/board/board_file'
require_relative 'chess/board'
require_relative 'chess/position_coding'
require_relative 'chess/position'
require_relative 'chess/pieces'
require_relative 'chess/pieces/knight'
require_relative 'chess/pieces/king'
require_relative 'chess/pieces/bishop'
require_relative 'chess/pieces/rook'
require_relative 'chess/pieces/queen'
require_relative 'chess/pieces/pawn'

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
