# frozen_string_literal: true

# project namespace
module CLIChess
  # StringNode holds a string value
  class StringNode < Node
    include Serialize

    attr_reader :type, :value

    def cont_initialize(**kwargs)
      @type = :string
      @value = kwargs[:parms][:value][1...-1]
    end

    def pretty_print(indent = 0)
      puts "#{indent_str(indent)}#{self.class.name}, value = #{value}"
    end

    def to_s
      "type = #{self.class.name}, value = #{value}" \
        ", line: #{line} (#{start_pos})"
    end

    def self.json_create(hash)
      obj = allocate
      obj.json_create(allocate, hash)
    end
  end
end
