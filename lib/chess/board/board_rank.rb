# frozen_string_literal: true

# namespace for the project.
module CLIChess
  # given a location return information about
  # other locations on the same rank.
  class BoardRank
    def initialize
      @chessboard = nil
      @ref_piece = nil
      @results = []
      @start = nil
      @stop = nil
      @temp_start = 0
    end

    def possible_moves(piece, chessboard)
      return nil unless piece

      reset(piece, chessboard)

      calculate_initial_coordinates
      locate_endpoints
      update_results
      prune_endpoints
      prune_start_location
      results
    end

    private

    attr_accessor :chessboard, :ref_piece, :results, :start, :stop, :temp_start

    def update_results
      self.results = results.slice(start, stop - start + 1)
    end

    def reset(piece, chessboard)
      # reset instance variables for a new piece
      self.chessboard = chessboard
      self.ref_piece = piece
      self.results = []
      self.start = nil
      self.stop = nil
      self.temp_start = 0
    end

    def calculate_initial_coordinates
      # get all coordinate pairs on the same
      # rank as the piece under investigation.
      rank = ref_piece.position.rank
      ranks = (0...8).to_a
      self.results = ranks.map do |idx|
        [idx, rank]
      end
    end

    def locate_endpoints
      # search left to right for occupied positions
      # start and stop will locate edge of the board
      # or the pieces immediately left and right of
      # the piece under investigation.
      self.start = nil
      self.stop = nil
      self.temp_start = 0
      results.each_with_index do |coord, idx|
        assign_start_and_stop_indicies(coord, idx)
        break unless stop.nil?
      end
      self.stop = 7 if stop.nil?

      nil
    end

    def assign_start_and_stop_indicies(coord, idx)
      update_start(coord)
      return nil if coord == ref_piece.position.to_a

      update_temp_start(idx, coord)
      update_stop(idx, coord)
    end

    def update_start(coord)
      self.start = temp_start if coord == ref_piece.position.to_a
    end

    def update_temp_start(idx, coord)
      self.temp_start = idx unless chessboard.board[coord[0]][coord[1]].nil?
    end

    def update_stop(idx, coord)
      self.stop = idx unless chessboard.board[coord[0]][coord[1]].nil? || start.nil?
    end

    def prune_endpoints
      # if the nearest piece is friendly, remove it.
      [0, -1].each do |idx|
        file, rank = results[idx]
        blocker = chessboard.board[file][rank]
        results.delete_at(idx) unless blocker.nil? || blocker.team != ref_piece.team
      end
    end

    def prune_start_location
      results.delete(ref_piece.position.to_a)
    end
  end
end
