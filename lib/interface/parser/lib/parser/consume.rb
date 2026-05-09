# frozen_string_literal: true

# project namespace
module CLIChess
  # consume methods, used in recursive descent
  class Consume
    attr_reader :parser

    def initialize(parser: nil)
      @parser = parser
    end

    def consume(expected_type: nil, expected_value: nil)
      if current.nil?
        # ran out of tokens prematurely.
        insert_token(error_token(
                       error_msg: 'SyntaxError, unexpected end of line',
                       position_offset: 1
                     ))
        return
      end

      if parse_error?(expected_type, expected_value)
        msg = "SyntaxError: unexpected token type \"#{current.type}\", " \
              "value \"#{current.name}\""
        insert_token(error_token(error_msg: msg))
        return
      end

      advance
    end

    def parse_error?(expected_type, expected_value)
      return true unless expected_type?(expected_type)
      return true unless expected_value?(expected_value)

      false
    end

    def expected_type?(type = nil)
      return true if type.nil?

      type.any?(current.type)
    end

    def expected_value?(value = nil)
      return true if value.nil?

      value.any?(current.name)
    end
  end
end
