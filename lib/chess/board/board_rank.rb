# frozen_string_literal: true

# namespace for the project.
module CLIChess
  # given a location return information about
  # other locations on the same rank.
  class BoardRank < BoardOffDiagonal
    private

    def calculate_initial_coordinates
      # get all coordinate pairs on the same
      # rank as the piece under investigation.
      rank = ref_piece.position.rank
      ranks = (0...8).to_a
      self.results = ranks.map do |idx|
        [idx, rank]
      end
    end
  end
end
