# frozen_string_literal: true

# project namespace.
module CLIChess
  # chesspiece: pawn.
  class Pawn < ChessPiece
    def cont_initialize
      @description = 'pawn'
      @movement = [[0, 1]]
      @king = false
      @value = 5
    end

    def king?
      @king
    end

    def next_states
      results = []
      movement.each do |move|
        new_position = calculate_new_position(move, position)
        next unless new_position.valid?
        next if board.occupied?(new_position)

        results << Pawn.new(team: team,
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
      puts move.inspect
      new_pos << (cur_file + move[0])
      new_pos << (cur_rank + (move[1] * direction))
      Position.new(board_pos: positioncodes.encoder[new_pos])
    end
  end
end
