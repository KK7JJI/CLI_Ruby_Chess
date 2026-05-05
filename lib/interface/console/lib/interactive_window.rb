# frozen_string_literal: true

# namespace for the project
module CLIChess
  # window which allows text scrolling
  class InteractiveWindow < BaseWindow
    attr_accessor :line_number, :prompt, :display, :buffer
    attr_reader :tokenizer, :parser, :evaluator

    def cont_initialize
      @buffer = WindowBuffer.new(rows: rows)
      @line_number = 1
      @tokenizer = CLIChess::Tokenizer.new
      @parser = CLIChess::Parser.new
      @evaluator = CLIChess::Evaluator.new(display: display)
    end

    # behavior here is to set the initial promp at the bottom right
    # of the window and the cursor to its right.
    # on enter the prompt should move up one line and a new prompt
    # entered incrementing the line_number.

    def user_input
      print VIDEO[:show_cursor]
      print VIDEO[:start_cursor_blink]

      # prime the prompt
      prompt = "chess:#{line_number.to_s.rjust(4, '0')}>"
      buffer.push(prompt)
      refresh

      prompt_row = win_origin[0] + rows - 2
      prompt_col = win_origin[1] + 1 + prompt.length + 2

      # REPL loop
      while true
        # position cursor to the end of the prompt
        print "\e[#{prompt_row};#{prompt_col}H"
        user_input = gets
        break if user_input.nil? # Ctrl-D

        user_input = user_input.strip
        break if user_input == 'exit'

        begin
          result = evaluate_line(input: user_input)
          buffer.append_last(user_input)
          msg = add_line_breaks("    result => (#{result})")
          msg.each { |item| buffer.push(item) }
        rescue StandardError => e
          print "Error: #{e.message}"
        end

        self.line_number += 1
        prompt = "chess:#{line_number.to_s.rjust(4, '0')}>"
        buffer.push(prompt)
        refresh
      end
      display.clear_screen
    end

    def evaluate_line(input: nil)
      tokenizer.tokenize_line_input(statement: input)
      parser.parse_line(token_list: tokenizer.tokens, statement: input)

      evaluator.evaluate_line(parser_tree: parser.parser_tree,
                              statement: input)
    end

    def add_line_breaks(msg)
      new_msg = []
      until msg.empty?
        temp = msg.slice(0, cols - 3)
        new_msg << temp
        msg = msg.sub(temp, '')
      end
      new_msg
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
