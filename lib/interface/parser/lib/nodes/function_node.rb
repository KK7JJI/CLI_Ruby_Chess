# frozen_string_literal: true

# project namespace
module CLIChess
  # IntegerNode holds an integer value
  class FunctionNode < Node
    include Serialize

    attr_reader :func, :args

    def cont_initialize(**kwargs)
      @type = :function
      @func = kwargs[:parms][:func]
      @args = kwargs[:parms][:args] || []
    end

    def pretty_print(indent = 0)
      puts "#{indent_str(indent)}#{self.class.name}, function = #{func}"
    end

    def to_s
      "Function: #{func}"
    end
  end
end
