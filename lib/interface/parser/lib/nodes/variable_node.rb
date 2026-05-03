# frozen_string_literal: true

# project namespace
module CLIChess
  # VariableNode holds a variable
  class VariableNode < Node
    include Serialize

    attr_reader :type, :value

    def cont_initialize(**kwargs)
      @type = :variable
      @value = kwargs[:parms][:value]
    end

    def pretty_print(indent = 0)
      puts "#{indent_str(indent)}#{self.class.name}, name = #{value}"
    end

    def to_s
      "type = #{self.class.name}, name = #{value}" \
        ", line: #{line} (#{start_pos})"
    end

    def self.json_create(hash)
      obj = allocate
      obj.json_create(allocate, hash)
    end
  end
end
