# frozen_string_literal: true

# namespace for the project
module CLIChess
  # superclass for console windows
  class BaseWindow
    include Constants
    include OutputMSG

    attr_accessor :reference, :win_origin, :rows, :cols, :cmds, :windows,
                  :id, :name

    def initialize(name: 'MAIN',
                   id: 0,
                   metrics: nil,
                   display: nil)
      @display = display
      @name = name
      @id = id
      @reference = metrics.reference
      @win_origin = screen_relative_coords(metrics.new_origin)
      @rows = metrics.rows
      @cols = metrics.cols
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
      print "\e7"
      col = 1 + win_origin[1]
      line = win_origin[0]
      (rows - 2).times do
        line += 1
        msg = "\e[#{line};#{col}H"
        msg += ' ' * (cols - 2)
        print msg
      end
      print "\e8"
    end

    def add_borders
      line = win_origin[0]

      cmds << top_border
      cmds << title_text

      (rows - 2).times do
        line += 1
        cmds << left_border(line)
        cmds << right_border(line)
      end

      line += 1
      cmds << bottom_border(line)
    end

    def left_border(line)
      first_col = win_origin[1]
      "\e[#{line};#{first_col}H#{BOX[:v]}"
    end

    def right_border(line)
      last_col = win_origin[1] + cols - 1
      "\e[#{line};#{last_col}H#{BOX[:v]}"
    end

    def top_border
      cursor_line = win_origin[0]
      cursor_col = win_origin[1]
      msg = "\e[#{cursor_line};#{cursor_col}H"
      msg += BOX[:tl]
      msg += BOX[:h] * (cols - 2)
      msg += BOX[:tr]
      msg
    end

    def title_text
      txt = " #{id} "
      txt = " #{name[0, cols - 6]} " unless name.nil?

      msg = title_cursor_pos(txt)
      msg += txt
      msg
    end

    def title_cursor_pos(txt)
      cursor_line = win_origin[0]
      cursor_col = win_origin[1]
      cursor_col += (cols / 2)

      cursor_col -= (txt.length / 2)
      "\e[#{cursor_line};#{cursor_col}H"
    end

    def bottom_border(line)
      cursor_col = win_origin[1]
      msg = "\e[#{line};#{cursor_col}H"
      msg += BOX[:bl]
      msg += BOX[:h] * (cols - 2)
      msg += BOX[:br]
      msg
    end

    def to_s
      "#{format('%03d', id)}: #{name} -> class=#{self.class}"
    end
  end
end
