# frozen_string_literal: true

# project namespace
module CLIChess
  # arithmatic, add integer values and return sum.
  class AddInts
    include ErrorMessage
    include FunctionArgs

    attr_reader :evaluator

    def initialize(evaluator: nil)
      @evaluator = evaluator
    end

    def func_add_ints(node)
      args = arg_values(node, evaluator)
      unless args.all? { |arg| arg.is_a?(Integer) }
        msg = 'Invalid arguments, expected integers'
        return evaluator_error(node, msg: msg)
      end

      # verify all args are integer_nodes
      IntegerValue.new(parms: {
                         type: :integer,
                         value: args.sum,
                         line: node.line,
                         start_pos: node.start_pos
                       })
    end
  end
end
