# frozen_string_literal: true

# project namespace
module CLIChess
  # tokenizer token class
  class Token
    include Serialize

    attr_accessor :line, :col, :type, :name, :has_value

    def initialize(type: nil,
                   name: nil,
                   line: 0,
                   col: 0)
      @type = type
      @name = name
      @line = line
      @col = col
    end

    def to_s
      "token: type = #{type}, name = #{name} on line #{line}, pos #{col}"
    end

    def self.json_create(hash)
      obj = allocate
      obj.json_create(allocate, hash)
    end
  end
end
