# frozen_string_literal: true

# chess bishop.
module CLIChess
  # chesspiece: king.
  class Bishop < ChessPiece
    def cont_initialize
      @description = 'bishop'
      @movement = []
      @king = false
      @value = 7
    end

    def king?
      @king
    end

    def next_states
      results = []
      locations = board.diagonals(self)
      locations.each do |location|
        new_position = Position.new(board_pos: positioncodes.encoder[location])
        next if board.occupied?(new_position)

        results << Bishop.new(team: team,
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
