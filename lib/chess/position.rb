# frozen_string_literal: true

# project namespace
module CLIChess
  # describes locations on a chess board
  class Position
    attr_accessor :board_pos, :positioncodes

    def initialize(board_pos: nil)
      @board_pos = board_pos
      @positioncodes = PositionCoding.new
    end

    def file
      positioncodes.decoder[board_pos][:my_file]
    end

    def rank
      positioncodes.decoder[board_pos][:my_rank]
    end

    def to_a
      [file, rank]
    end

    def to_h
      key = board_pos.to_s
      { key => { file: file, rank: rank } }
    end

    def valid?
      return true if positioncodes.decoder[board_pos]

      false
    end

    def ==(other)
      return false unless other
      return false unless other.is_a?(Position)
      return false unless board_pos == other.board_pos

      true
    end

    def to_s
      "#{board_pos} => rank: #{rank + 1}, file: #{file + 1}"
    end
  end
end
