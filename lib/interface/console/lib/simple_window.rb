# frozen_string_literal: true

# namespace for the project
module CLIChess
  # window, no scrolling support
  class SimpleWindow < DisplayWindow
    def add_text(text, **kwargs)
      # trucate text overflowing the left side
      option = kwargs[:option]
      col = kwargs[:col]
      row = kwargs[:row]

      center_in_window(text) if option == :center_in_window
      center_in_row(text, row: row) if option == :center_in_row
      insert_at(text, row: row, col: col) if option == :insert_at
      justify_left(text, row: row) if option == :justify_left
      justify_right(text, row: row) if option == :justify_right

      nil
    end

    private

    attr_accessor :window_text

    def cont_initialize
      @window_text = {}
    end

    def queue_msg(row, col, text)
      cursor = "\e[#{row};#{col}H"
      msg = text.to_s
      window_text[cursor] = msg
      cmds << "#{cursor}#{msg}"
    end

    def justify_left(text, row: 1)
      # truncate text which overflows the line
      text = text[0, cols - 2]

      row += win_origin[0]
      col = 1 + win_origin[1]

      # trucate text overflowing top a and bottom
      return nil if row <= win_origin[0]
      return nil if row >= win_origin[0] + rows - 1

      queue_msg(row, col, text)
    end

    def justify_right(text, row: 1)
      # truncate text which overflows the line
      text = text[0, cols - 2]

      row += win_origin[0]
      col =  cols - text.length + win_origin[1] - 1

      # trucate text overflowing top or bottom
      return nil if row <= win_origin[0]
      return nil if row >= win_origin[0] + rows - 1

      queue_msg(row, col, text)
    end

    def insert_at(text, row: 1, col: 1)
      if col < 1
        text = text[((-1 * col) + 1), text.length]
        col = 1
      end

      # truncate text overflowing the right side
      text = text[0, cols - col - 1]

      row += win_origin[0]
      col += win_origin[1]

      # trucate text overflowing top a and bottom
      return nil if row <= win_origin[0]
      return nil if row >= win_origin[0] + rows - 1

      queue_msg(row, col, text)
    end

    def center_in_window(text)
      text = fit_text_to_row(text)
      row = center_vertical
      col = center_text_horizontal(text)

      queue_msg(row, col, text)
    end

    def center_in_row(text, row: 1)
      # trucate text overflowing top a and bottom
      row += win_origin[0]
      return nil if row <= win_origin[0]
      return nil if row >= win_origin[0] + rows - 1

      text = fit_text_to_row(text)
      col = center_text_horizontal(text)

      queue_msg(row, col, text)
    end

    def fit_text_to_row(text)
      x = text.length - (cols - 2)
      text = text[x / 2, cols - 2] unless x <= 0
      text
    end

    def center_text_horizontal(text)
      (cols / 2) + win_origin[1] - (text.length / 2)
    end

    def center_vertical
      (rows / 2) + win_origin[0]
    end
  end
end
