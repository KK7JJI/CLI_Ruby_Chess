# frozen_string_literal: true

# namespace for the project
module CLIChess
  # superclass for console windows
  class BaseWindow
    include Constants

    attr_accessor :reference, :win_origin, :rows, :cols, :cmds, :windows, :name

    def initialize(name: 'MAIN',
                   id: 0,
                   reference: nil,
                   new_origin: [0, 0],
                   rows: 0,
                   cols: 0)
      @name = name
      @id = id
      @reference = reference || [1, 1]
      @win_origin = screen_relative_coords(new_origin)
      @rows = rows
      @cols = cols
      @cmds = []

      add_borders
      cont_initialize
    end

    def cont_initialize
      raise NotImplementedError, '#cont_initialize must be defined.'
    end

    def refresh
      raise NotImplementedError, '#refresh must be defined.'
    end

    def screen_relative_coords(origin)
      [reference[0] + origin[0], reference[1] + origin[1]]
    end

    def clear_window
      # purge prior display commands

      # print blank lines to erase current display content
      col = 1 + win_origin[1]
      line = win_origin[0]
      (rows - 2).times do |row|
        line += 1
        msg = "\e[#{line};#{col}H"
        msg += ' ' * (cols - 2)
        print msg
      end
    end

    def add_borders
      line = win_origin[0]
      first_col = win_origin[1]
      last_col = win_origin[1] + cols - 1

      msg = "\e[#{line};#{win_origin[1]}H"
      msg += BOX[:tl]
      msg += BOX[:h] * (cols - 2)
      msg += BOX[:tr]
      cmds << msg

      (rows - 2).times do |idx|
        line += 1
        msg = "\e[#{line};#{first_col}H#{BOX[:v]}"
        cmds << msg
        msg = "\e[#{line};#{last_col}H#{BOX[:v]}"
        cmds << msg
      end

      line += 1
      msg = "\e[#{line};#{first_col}H"
      msg += BOX[:bl]
      msg += BOX[:h] * (cols - 2)
      msg += BOX[:br]
      cmds << msg
    end
  end
end
