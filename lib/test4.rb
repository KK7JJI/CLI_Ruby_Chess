# frozen_string_literal: true

require_relative 'interface/interface'

def evaluate(expr)
  tokenizer = CLIChess::Tokenizer.new
  parser = CLIChess::Parser.new
  evaluator = CLIChess::Evaluator.new

  tokenizer.tokenize_line_input(statement: expr)
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
  evaluator.evaluate_file_input
end

expr = 'a+2='
puts "result => (#{evaluate(expr)})"

# filename = 'assignment.chess'
# run_script(filename)

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
