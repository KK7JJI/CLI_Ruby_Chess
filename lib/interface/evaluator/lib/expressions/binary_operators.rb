# frozen_string_literal: true

# project namespace
module CLIChess
  # evaluator binary operation
  class BinaryOp
    include ErrorMessage

    attr_reader :evaluator

    def initialize(evaluator: nil)
      @evaluator = evaluator
    end

    def binary_operations(node)
      left = evaluator.walk(node.left_node)
      right = evaluator.walk(node.right_node)

      return left if left.type == :error
      return right if right.type == :error

      evaluate(
        node.value,
        left,
        right
      )
    end

    def evaluate(operator, l_value, r_value)
      unless l_value.respond_to?(operator)
        msg = "Operator \"#{method}\" not supported for #{l_value.type}"
        return evaluator_error(l_value, msg: msg)
      end
      l_value.public_send(operator, r_value)
    end
  end
end
