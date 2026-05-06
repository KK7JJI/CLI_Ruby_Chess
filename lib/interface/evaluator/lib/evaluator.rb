# frozen_string_literal: true

# namespace for the project
module CLIChess
  # evaluate parser generated nodes
  class Evaluator
    include Serialize
    include ErrorMessage

    attr_reader :variables, :result, :statement, :functions, :commands, :display

    def initialize(display: nil)
      @display = display
      @variables = {}
      @result = nil
      @statement = nil

      @binary_expression = BinaryOp.new(evaluator: self)
      @unary_expression = UnaryOp.new(evaluator: self)
      @resolve_variables = ResolveVariables.new
      @assign_variables = AssignVariables.new(evaluator: self)
      @runtime_value = RuntimeValue.new
      @eval_functions = EvalFunctions.new(evaluator: self)
      @eval_commands = EvalCommands.new(evaluator: self)

      @eval_console_commands = EvalConsoleCommands.new(
        evaluator: self,
        display: display
      )
    end

    def evaluate_line(parser_tree: nil, statement: nil)
      return if parser_tree.nil?

      self.statement = statement
      self.result = walk(parser_tree)
      return result.value if result.respond_to?(:value)

      result.to_s
    end

    def evaluate_file_input(read_from: 'parser.data')
      File.foreach(read_from) do |input_line|
        statement, root_node = load_parsed_line(input_line)
        evaluate_line(parser_tree: root_node, statement: statement)
      end
      result
    end

    def walk(node)
      type = node.type.to_sym

      case type
      when :console_command
        eval_console_commands.run_command(node)

      when :command
        eval_commands.run_command(node)

      when :assignment
        assign_variables.set_variable(node)

      when :function
        eval_functions.evaluate_function_call(node)

      when :binary
        binary_expression.binary_operations(node)

      when :unary
        unary_expression.unary_operation(node)

      when :boolean, :string, :integer
        runtime_value.runtime_value(node)

      when :variable
        resolve_variables.resolve_variable(node, variables)

      when :error
        copy_error_message(node)

      else
        evaluator_error(node,
                        msg: "evaluation not implemented for type \"#{type}\"")
      end
    end

    def inspect
      "Statement: #{statement}\nResult=#{result}"
    end

    def to_s
      result
    end

    private

    attr_reader :binary_expression, :unary_expression, :resolve_variables,
                :assign_variables, :runtime_value, :eval_functions,
                :eval_commands, :eval_console_commands
    attr_writer :result, :statement

    def load_parsed_line(statement)
      parser_statement = rebuild(JSON.load(statement))
      [parser_statement[0], parser_statement[1]]
    end

    def copy_error_message(node)
      ErrorMsg.new(parms: { type: node.type,
                            line: node.line,
                            start_pos: node.start_pos,
                            error_msg: node.error_msg })
    end
  end
end
