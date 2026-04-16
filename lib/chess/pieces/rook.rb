# frozen_string_literal: true

# chess bishop.
module CLIChess
  # chesspiece: king.
  class Rook < ChessPiece
    def cont_initialize
      @description = 'rook'
      @movement = []
      @king = false
      @value = 8
    end

    def king?
      @king
    end

    def next_states
      results = []
      locations = board.rank_and_file(self)
      locations.each do |location|
        new_position = Position.new(board_pos: positioncodes.encoder[location])
        next if board.occupied?(new_position)

        results << Rook.new(team: team,
                            position: new_position,
                            ghost: true,
                            board: board)
      end

      results
    end

    private

    attr_accessor :movement, :positioncodes
  end
end
