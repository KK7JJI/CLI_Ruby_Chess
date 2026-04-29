# frozen_string_literal: true

# project namespace
module CLIChess
  # IntegerNode holds an integer value
  class IntegerNode < Node
    include Serialize

    attr_reader :type, :value

    def cont_initialize(**kwargs)
      @type = :integer
      @value = kwargs[:parms][:value].to_i

      return if integer?(kwargs[:parms][:value])

      raise TypeError,
            "#{kwargs[:parms][:value]} is not Integer, pos #{start_pos}"
    end

    def integer?(value)
      value.to_s == value.to_i.to_s
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
