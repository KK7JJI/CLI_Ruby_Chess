# frozen_string_literal: true

# project namespace
module CLIChess
  # binary operator
  class BinaryOpNode < Node
    include Serialize

    attr_reader :type, :value, :left_node, :right_node

    def cont_initialize(**kwargs)
      @type = :binary
      @value = kwargs[:parms][:value]
      @left_node = kwargs[:parms][:left_node]
      @right_node = kwargs[:parms][:right_node]
    end

    def pretty_print(indent = 0)
      puts "#{indent_str(indent)}#{self.class.name} (#{value})"

      puts "#{indent_str(indent + 2)}left:"
      @left_node.pretty_print(indent + 4) unless @left_node.nil?

      puts "#{indent_str(indent + 2)}right:"
      @right_node.pretty_print(indent + 4) unless @right_node.nil?
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
