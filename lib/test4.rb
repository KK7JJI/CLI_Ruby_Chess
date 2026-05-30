# frozen_string_literal: true

require_relative 'interface/interface'

def evaluate(expr)
  tokenizer = CLIChess::Tokenizer.new
  parser = CLIChess::Parser.new
  evaluator = CLIChess::Evaluator.new

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
  evaluator
end

# expr = 'new_window name="SJH", type="simple", origin="5;5", cols=20, rows=40'
# expr = 'new_window'
# expr = 'activate_window name="WIN1"'
# expr = 'move_window names="WIN2", origin="1;1"'
# result = evaluate(expr)
# puts "result => (#{result})"

expr = 'resize_window something=5, loc="10;10"'
result = evaluate(expr)
puts "result => (#{result})"

# filename = 'sample.chess'
# puts run_script(filename).inspect

# repl = CLIChess::REPL.new
# repl.repl_loop

# history = CLIChess::History.new
# 105.times do |idx|
#   history.push('hi' + idx.to_s)
# end
# puts history.last
# puts history.last(101)
# puts history
# puts history.last(9)
