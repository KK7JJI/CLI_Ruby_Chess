# frozen_string_literal: true

# project namespace
module CLIChess
  # evaluator extract function arguments and
  # return them in an array for convenience
  module FunctionArgs
    def arg_values(node, evaluator)
      node.args.map do |arg|
        evaluator.walk(arg).value
      end
    end
  end
end
