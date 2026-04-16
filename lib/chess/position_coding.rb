# frozen_string_literal: true

# project namespace
module CLIChess
  # describes a row, col location
  class PositionCoding
    attr_accessor :encoder, :decoder

    BOARD_SIZE = 8

    def initialize
      @decoder = {}
      @encoder = {}
      init_board_position_codes
    end

    def encode(rank: nil, file: nil)
      # encode row, col into a1, a2, a3 ...
      encoder([file, rank])
    end

    def decode(pos: nil)
      # returns [file, rank]
      decode[pos]
    end

    def init_board_position_codes
      (0...BOARD_SIZE).each do |file|
        notation = (0...BOARD_SIZE).map do |idx|
          ('a'.ord + file).chr + (idx + 1).to_s
        end
        (0...BOARD_SIZE).each do |rank|
          decoder[notation[rank]] = { my_file: file, my_rank: rank }
          encoder[[file, rank]] = notation[rank]
        end
      end
    end
  end
end
