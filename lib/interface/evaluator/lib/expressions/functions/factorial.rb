# frozen_string_literal: true

# project namespace
module CLIChess
  # arithmatic, computes the factorial of an integer.
  class Factorial
    include ErrorMessage
    include FunctionArgs

    attr_reader :evaluator

    def initialize(evaluator: nil)
      @evaluator = evaluator
    end

    def func_factorial(node)
      args = arg_values(node, evaluator)
      unless args.length == 1
        msg = "Received \"#{args.length}\" arguments, expected \"1\""
        return evaluator_error(node, msg: msg)
      end

      unless args[0].is_a?(Integer)
        msg = "Expected integer argument, got \"#{args[0]}\""
        return evaluator_error(node,
                               msg: msg)
      end

      unless args[0] >= 0
        msg = "Expected arg >= 0, got \"#{args[0]}\""
        return evaluator_error(node,
                               msg: msg)
      end

      value = 0
      value = 1 if args[0].zero?
      if value == 0
        value = (1..args[0]).to_a.reduce(1) do |prod, num|
          prod * num
        end
      end

      IntegerValue.new(parms: {
                         type: :integer,
                         value: value,
                         line: node.line,
                         start_pos: node.start_pos
                       })
    end
  end
end
