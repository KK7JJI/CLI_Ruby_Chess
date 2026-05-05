# frozen_string_literal: true

# project namespace
module CLIChess
  # IntegerNode holds an integer value
  class CommandNode < Node
    include Serialize

    attr_reader :type, :value, :args

    def cont_initialize(**kwargs)
      @type = :command
      @value = kwargs[:parms][:value]
      @args = kwargs[:parms][:args]
    end

    def pretty_print(indent = 0)
      puts "#{indent_str(indent)}#{self.class.name}, #{self}"
    end

    def to_s
      "Command: #{value}, #{args.length} arguments."
    end
  end
end
