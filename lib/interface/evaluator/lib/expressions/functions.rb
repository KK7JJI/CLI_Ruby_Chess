# frozen_string_literal: true

# project namespace
module CLIChess
  # evaluator evaluate defined functions
  class EvalFunctions
    include ErrorMessage

    attr_reader :functions

    def initialize(evaluator: nil)
      @evaluator = evaluator

      @addints = AddInts.new(evaluator: @evaluator)
      @prodints = ProdInts.new(evaluator: @evaluator)
      @factorial = Factorial.new(evaluator: @evaluator)

      @functions = {
        'add_ints' => @addints.method(:func_add_ints),
        'prod_ints' => @prodints.method(:func_prod_ints),
        'factorial' => @factorial.method(:func_factorial)
      }
    end

    def evaluate_function_call(node)
      return functions[node.func].call(node) if functions.key?(node.func)

      msg = "Undefined function #{node.func}"
      ErrorMsg.new(parms: {
                     start_pos: node.start_pos,
                     line: node.line,
                     error_msg: msg
                   })
    end
  end
end
