# frozen_string_literal: true

# namespace for the project
module CLIChess
  # window which allows text scrolling
  class InteractiveWindow < BaseWindow
    attr_accessor :line_number, :prompt, :display, :buffer

    def cont_initialize
      @buffer = WindowBuffer.new(rows: rows)
      @line_number = 1
      @history = []
    end

    # behavior here is to set the initial promp at the bottom right
    # of the window and the cursor to its right.
    # on enter the prompt should move up one line and a new prompt
    # entered incrementing the line_number.

    def user_input
      print VIDEO[:show_cursor]
      print VIDEO[:start_cursor_blink]

      prompt = "chess:#{line_number.to_s.rjust(4, '0')}>"
      buffer.push(prompt)
      refresh
      prompt_row = win_origin[0] + rows - 2
      prompt_col = win_origin[1] + 1 + prompt.length + 2

      # REPL loop
      while true
        print "\e[#{prompt_row};#{prompt_col}H"
        user_input = gets.chomp
        buffer.append_last(user_input)
        self.line_number += 1
        prompt = "chess:#{line_number.to_s.rjust(4, '0')}>"
        buffer.push(prompt)
        refresh
      end
    end

    def refresh
      clear_window
      add_borders
      cmds.each do |cmd|
        print cmd
      end

      row = win_origin[0] + rows - 2
      buffer.refresh.each do |line|
        col = win_origin[1] + 2
        print "\e[#{row};#{col}H#{line}"
        row -= 1
      end
    end
  end
end
