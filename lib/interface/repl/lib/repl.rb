# frozen_string_literal: true

module CLIChess
  # REPL loop
  class REPL
    attr_reader :tokenizer, :parser, :evaluator
    attr_accessor :history

    def initialize
      @tokenizer = CLIChess::Tokenizer.new
      @parser = CLIChess::Parser.new
      @evaluator = CLIChess::Evaluator.new
      @history = CLIChess::History.new
    end

    def evaluate_line(input: nil)
      tokenizer.tokenize_line_input(statement: input)
      parser.parse_line(token_list: tokenizer.tokens, statement: input)

      evaluator.evaluate_line(parser_tree: parser.parser_tree,
                              statement: input)
    end

    def repl_loop
      loop do
        print '> '
        line = gets
        break if line.nil? # Ctrl-D

        line = line.strip
        next if line.empty? || line.start_with?('#')

        history.push(line)

        break if line == 'exit'

        begin
          result = evaluate_line(input: line)
          puts "result => (#{result})"
        rescue Interrupt
          puts "\nInterrupted"
          break
        rescue StandardError => e
          puts "Error: #{e.message}"
        end
      end
    end
  end
end
