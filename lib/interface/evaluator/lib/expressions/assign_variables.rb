# frozen_string_literal: true

# project namespace
module CLIChess
  # evaluator variable assignment
  class AssignVariables
    include ErrorMessage

    attr_reader :evaluator

    def initialize(evaluator: nil)
      @evaluator = evaluator
    end

    def set_variable(node)
      result = evaluator.walk(node.assigned_node)
      return result if result.type == :error

      evaluator.variables[node.value] =
        { value: result.value, type: result.type }
      result
    end
  end
end
