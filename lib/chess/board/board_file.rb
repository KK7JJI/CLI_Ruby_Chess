# frozen_string_literal: true

# namespace for the project.
module CLIChess
  # given a location return information about
  # other locations on the same file.
  class BoardFile < BoardLines
    def calculate_initial_coordinates
      # get all coordinate pairs on the same
      # rank as the piece under investigation.
      file = ref_piece.position.file
      files = (0...8).to_a
      self.results = files.map do |idx|
        [file, idx]
      end
    end
  end
end
