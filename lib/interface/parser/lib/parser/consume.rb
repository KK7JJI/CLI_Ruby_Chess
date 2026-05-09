# frozen_string_literal: true

# project namespace
module CLIChess
  # consume methods, used in recursive descent
  class Consume
    attr_reader :tokens

    def initialize(tokens: nil)
      @tokens = tokens
    end

    def consume(expected_type: nil, expected_value: nil)
      if tokens.current.nil?
        # ran out of tokens prematurely.
        tokens.insert_token(tokens.error_token(
                              error_msg: 'SyntaxError, unexpected end of line',
                              position_offset: 1
                            ))
        return
      end

      if parse_error?(expected_type, expected_value)
        msg = "SyntaxError: unexpected token type \"#{tokens.current.type}\", " \
              "value \"#{tokens.current.name}\""
        tokens.insert_token(tokens.error_token(error_msg: msg))
        return
      end

      tokens.advance
    end

    private

    def parse_error?(expected_type, expected_value)
      return true unless expected_type?(expected_type)
      return true unless expected_value?(expected_value)

      false
    end

    def expected_type?(type = nil)
      return true if type.nil?

      type.any?(tokens.current.type)
    end

    def expected_value?(value = nil)
      return true if value.nil?

      value.any?(tokens.current.name)
    end
  end
end
