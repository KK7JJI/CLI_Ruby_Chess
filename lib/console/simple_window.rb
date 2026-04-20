# frozen_string_literal: true

# namespace for the project
module CLIChess
  # window, no scrolling support
  class SimpleWindow < BaseWindow
    def add_text(text, **kwargs)
      # trucate text overflowing the left side
      option = kwargs[:option]
      col = kwargs[:col]
      row = kwargs[:row]

      center_in_window(text) if option == :center_in_window
      center_in_row(text, row: row) if option == :center_in_row
      insert_at(text, row: row, col: col) if option == :insert_at

      nil
    end

    private

    def cont_initialize
      nil
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

      msg = "\e[#{row};#{col}H#{text}"
      cmds << msg
    end

    def center_in_window(text)
      text = fit_text_to_row(text)
      row = center_vertical
      col = center_text_horizontal(text)

      msg = "\e[#{row};#{col}H#{text}"
      cmds << msg
    end

    def center_in_row(text, row: 1)
      # trucate text overflowing top a and bottom
      row += win_origin[0]
      return nil if row <= win_origin[0]
      return nil if row >= win_origin[0] + rows - 1

      text = fit_text_to_row(text)
      col = center_text_horizontal(text)
      msg = "\e[#{row};#{col}H#{text}"
      cmds << msg
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
