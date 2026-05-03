# frozen_string_literal: true

# project namespace
module CLIChess
  # IntegerNode holds an integer value
  class ErrorNode < Node
    attr_reader :error_msg

    def cont_initialize(**kwargs)
      @type = :error
      @error_msg = kwargs[:parms][:error_msg]
    end

    def pretty_print(indent = 0)
      puts "#{indent_str(indent)}#{self.class.name}, value = #{error_msg}"
    end

    def to_s
      "type = #{type}, value = #{error_msg}" \
        ", line: #{line} (#{start_pos})"
    end
  end
end
