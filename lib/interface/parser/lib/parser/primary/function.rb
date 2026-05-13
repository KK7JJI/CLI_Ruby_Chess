# frozen_string_literal: true

# project namespace
module CLIChess
  # consume methods, used in recursive descent
  class Function
    attr_reader :tokens, :parser, :consume

    def initialize(parser: nil, consume: nil, tokens: nil)
      @tokens = tokens
      @parser = parser
      @consume = consume
    end

    def new_function_node
      return nil unless function?

      token = tokens.current
      consume.consume(expected_type: [:variable])
      consume.consume(expected_type: [:punctuation], expected_value: ['('])

      args = function_args
      consume.consume(expected_type: [:punctuation], expected_value: [')'])
      function_node(token, args)
    end

    private

    def function_args
      return [] if tokens.current.nil?
      if tokens.current.name == ')' && tokens.current.type == :punctuation
        return []
      end

      args = []
      args << parser.parse_new_expression
      while tokens.current && tokens.current.type == :punctuation && tokens.current.name == ','
        consume.consume(expected_type: [:punctuation], expected_value: [','])
        args << parser.parse_new_expression
      end
      args
    end

    def function_node(token, args)
      FunctionNode.new(parms: {
                         type: :function,
                         line: token.line,
                         start_pos: token.col,
                         func: token.name,
                         args: args
                       })
    end

    def function?
      return false if tokens.current.nil?
      return false unless tokens.current.type == :variable
      return false unless tokens.peek_next
      return false unless tokens.peek_next.type == :punctuation
      return false unless tokens.peek_next.name == '('

      true
    end
  end
end
