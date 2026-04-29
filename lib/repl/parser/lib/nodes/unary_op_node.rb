# frozen_string_literal: true

# project namespace
module CLIChess
  # Unary operator
  class UnaryOpNode < Node
    include Serialize

    attr_reader :type, :value, :node

    def cont_initialize(**kwargs)
      @type = :unary
      @value = kwargs[:parms][:value]
      @node = kwargs[:parms][:node]
    end

    def pretty_print(indent = 0)
      puts "#{indent_str(indent)}#{self.class.name} (#{value})"
      @node.pretty_print(indent + 2)
    end

    def to_s
      "type = #{self.class.name}, operator = #{value}" \
        ", line: #{line} (#{start_pos})"
    end

    def self.json_create(hash)
      obj = allocate
      obj.json_create(allocate, hash)
    end
  end
end
