# frozen_string_literal: true

# project namespace
module CLIChess
  # Unary operator
  class AssignmentNode < Node
    include Serialize

    attr_reader :type, :value, :assigned_node

    def cont_initialize(**kwargs)
      @type = :assignment
      @value = kwargs[:parms][:value]
      @assigned_node = kwargs[:parms][:assigned_node]
    end

    def pretty_print(indent = 0)
      puts "#{indent_str(indent)}AssignmentNode (#{value})"
      @assigned_node.pretty_print(indent + 2) unless @assigned_node.nil?
    end

    def to_s
      "type = #{self.class.name}, var name = \"#{value}\"" \
        ", line: #{line} (#{start_pos})"
    end

    def self.json_create(hash)
      obj = allocate
      obj.json_create(allocate, hash)
    end
  end
end
