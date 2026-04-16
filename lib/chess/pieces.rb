# frozen_string_literal: true

# namespace for the project
module CLIChess
  TEAM = {
    0 => { color: 'White', direction: 1 },
    1 => { color: 'Black', direction: -1 }
  }.freeze

  VIDEO = {
    bold: "\e[1m",
    norm: "\e[0m"
  }

  # a generic chess piece, abstract class.
  class ChessPiece
    attr_accessor :description, :position, :board, :team
    attr_reader :value

    def initialize(team: 0, position: nil, board: nil, ghost: nil)
      @description = 'U'
      @team = team
      @color = TEAM[@team][:color]
      @direction = TEAM[@team][:direction]
      @board = board
      @positioncodes = PositionCoding.new
      @position = position
      @value = 0
      @ghost = ghost
      cont_initialize
    end

    def ghost?
      return false unless ghost

      true
    end

    def king?
      raise NotImplementedError, '#king? must be defined in subclass.'
    end

    def cont_initialize
      raise NotImplementedError, '#cont_initialize must be defined in subclass.'
    end

    def next_moves
      next_states
    end

    def next_states
      raise NotImplementedError, '#next_states must be defined in subclass.'
    end

    def to_str
      to_s
    end

    def to_s
      msg = "#{TEAM[team][:color][0]}#{description[0]}"
      msg = "#{VIDEO[:bold]}#{msg}#{VIDEO[:norm]}" if king?
      msg = "#{VIDEO[:bold]}[]#{VIDEO[:norm]}" if ghost?

      msg
    end

    def <=>(other)
      value <=> other.value
    end

    def ==(other)
      return false unless other
      return false unless other.is_a?(ChessPiece)
      return false unless team == other.team
      return false unless description == other.description
      return false unless position == other.position

      true
    end

    private

    attr_accessor :direction, :ghost
  end
end
