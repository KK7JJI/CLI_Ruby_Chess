# frozen_string_literal: true

# project namespace
module CLIChess
  # consume methods, used in recursive descent
  class TokenList
    include Serialize

    attr_accessor :pos, :tokens, :statement

    def initialize
      @statement = nil
      @pos = 0
      @tokens = nil
    end

    def current
      tokens[pos]
    end

    def peek_next
      tokens[pos + 1]
    end

    def advance
      self.pos += 1
    end

    def insert_token(token)
      tokens[pos] = token
    end

    def load_list(statement, token_list)
      self.pos = 0
      self.tokens = token_list
      self.statement = statement
    end

    def load_tokens(input_line)
      # load tokens serialized by the tokenizer.
      token_list = rebuild(JSON.load(input_line))
      token_list[1].each do |token|
        token.type = token.type.to_sym
      end
      self.statement = token_list[0].chomp
      self.tokens = token_list[1]
    end

    def error_token(error_msg: nil, position_offset: 0)
      token = current || tokens[-1]
      Token.new(
        type: :error,
        name: error_msg,
        line: token.line,
        col: token.col + position_offset
      )
    end

    # garbage collection, if we didn't process all tokens
    # then there was an error in the original expression.
    def unexpected_tokens
      msg = "SyntaxError, unexpected token \"#{current.name}\""
      insert_token(error_token(error_msg: msg))
      error_node
    end
  end
end
