# frozen_string_literal: true

# project namespace
module CLIChess
  # evaluator unary operation
  class UnaryOp
    UNARY_METHODS = {
      '+' => :+@,
      '-' => :-@,
      '!' => :!
    }.freeze

    include ErrorMessage

    attr_reader :evaluator

    def initialize(evaluator: nil)
      @evaluator = evaluator
    end

    def unary_operation(node)
      x = evaluator.walk(node.node)
      return x if x.type == :error

      evaluate(
        node.value,
        x
      )
    end

    def evaluate(operator, value)
      method = UNARY_METHODS[operator]
      unless value.respond_to?(method)
        msg = "Operator \"#{method}\" not supported for #{value.type}"
        return evaluator_error(value, msg: msg)
      end
      value.public_send(method)
    end
  end
end
