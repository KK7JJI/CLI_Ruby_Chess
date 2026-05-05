# frozen_string_literal: true

require_relative 'interface/interface'

def evaluate(expr, display)
  tokenizer = CLIChess::Tokenizer.new
  parser = CLIChess::Parser.new
  evaluator = CLIChess::Evaluator.new(display: display)

  tokenizer.tokenize_line_input(statement: expr)
  puts tokenizer.tokens
  parser.parse_line(token_list: tokenizer.tokens, statement: expr)
  puts '======'
  parser.pretty_print
  puts '======'
  evaluator.evaluate_line(parser_tree: parser.parser_tree,
                          statement: expr)
end

def run_script(filename)
  tokenizer = CLIChess::Tokenizer.new
  parser = CLIChess::Parser.new
  evaluator = CLIChess::Evaluator.new

  tokenizer.tokenize_file_input(read_from: filename)
  parser.parse_file_input

  puts '======'
  parser.pretty_print
  puts '======'

  evaluator.evaluate_file_input
end

disp = CLIChess::Display.new

disp.new_window(name: 'SAMPLE',
                new_origin: [1, 1],
                rows: 40,
                cols: 20,
                option: :simple)

disp.new_window(name: 'WIN1',
                new_origin: [disp.rows - 8 - 3, 1],
                rows: 8,
                cols: disp.cols - 2,
                option: :interactive)
disp.refresh_display

disp.active_window.user_input
