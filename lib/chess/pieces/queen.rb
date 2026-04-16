# frozen_string_literal: true

# project namespace.
module CLIChess
  # chesspiece: queen.
  class Queen < ChessPiece
    def cont_initialize
      @description = 'Queen'
      @movement = []
      @king = false
      @value = 9
    end

    def king?
      @king
    end

    def next_states
      results = []
      locations = board.rank_and_file(self)
      locations += board.diagonals(self)

      locations.each do |location|
        new_position = Position.new(board_pos: positioncodes.encoder[location])
        next if board.occupied?(new_position)

        results << Queen.new(team: team,
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
