# frozen_string_literal: true

# project namespace
module CLIChess
  # arithmatic, multiply integer values and return sum.
  class ProdInts
    include ErrorMessage
    include FunctionArgs

    attr_reader :evaluator

    def initialize(evaluator: nil)
      @evaluator = evaluator
    end

    def func_prod_ints(node)
      args = arg_values(node, evaluator)
      unless args.all? { |arg| arg.is_a?(Integer) }
        msg = 'Invalid arguments, expected integers'
        return evaluator_error(node, msg: msg)
      end

      result = args.reduce { |prod, num| prod * num }
      IntegerValue.new(parms: {
                         type: :integer,
                         value: result,
                         line: node.line,
                         start_pos: node.start_pos
                       })
    end
  end
end
