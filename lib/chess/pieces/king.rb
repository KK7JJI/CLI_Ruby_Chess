# frozen_string_literal: true

# chess king.
module CLIChess
  # chesspiece: king.
  class King < ChessPiece
    def cont_initialize
      @description = 'King'
      @movement = [
        [1, 1], [1, -1],
        [-1, 1], [-1, -1],
        [0, 1], [0, -1],
        [1, 0], [-1, 0]
      ]
      @king = true
      @value = 10
    end

    def king?
      @king
    end

    def next_states
      results = []
      movement.each do |move|
        new_position = calculate_new_position(move, position)
        next unless new_position.valid?

        results << King.new(team: team,
                            position: new_position,
                            ghost: true,
                            board: board)
      end
      results
    end

    private

    attr_accessor :movement, :positioncodes

    def calculate_new_position(move, position)
      cur_file, cur_rank = position.to_a
      new_pos = []
      new_pos << (cur_file + (move[1] * direction))
      new_pos << (cur_rank + move[0])
      Position.new(board_pos: positioncodes.encoder[new_pos])
    end
  end
end
