# frozen_string_literal: true

# namespace for the project.
module CLIChess
  # given a location return information about
  # other locations on the same left diagonal.
  # (left - rising rank 0-7 to the left)
  class BoardLeftDiagonal < BoardLines
    def calculate_initial_coordinates
      file, rank = ref_piece.position.to_a
      x = [chessboard.board.length - file - 1, rank].min

      file += x
      rank -= x

      while continue_diag?(rank, file)
        results << [file, rank]
        file -= 1
        rank += 1
      end

      results
    end

    def continue_diag?(rank, file)
      return false if file > 7
      return false if rank > 7
      return false if rank.negative?
      return false if file.negative?

      true
    end
  end
end
