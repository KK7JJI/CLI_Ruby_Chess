# frozen_string_literal: true

require_relative 'repl/repl'

def evaluate(expr)
  tokenizer = CLIChess::Tokenizer.new
  parser = CLIChess::Parser.new
  evaluator = CLIChess::Evaluator.new

  tokenizer.tokenize_line_input(statement: expr)
  parser.parse_line(token_list: tokenizer.tokens, statement: expr)
  evaluator.evaluate_line(parser_root: parser.root,
                          statement: expr)
end

def run_script(filename)
  tokenizer = CLIChess::Tokenizer.new
  parser = CLIChess::Parser.new
  evaluator = CLIChess::Evaluator.new

  tokenizer.tokenize_file_input(read_from: filename)
  parser.parse_file_input
  evaluator.evaluate_file_input
end

# expr = 'false==true'
# evaluate(expr)

filename = 'sample.chess'
run_script(filename)
