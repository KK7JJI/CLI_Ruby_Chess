# frozen_string_literal: true

# namespace for the project
module CLIChess
  # VALUE_CLASSES = {
  #   integer: IntegerValue,
  #   string: StringValue,
  #   boolean: BooleanValue
  # }.freeze

  # UNARY_METHODS = {
  #   '+' => :+@,
  #   '-' => :-@,
  #   '!' => :!
  # }.freeze

  # evaluate parser nodes
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

      @commands = {
        'new_window' => method(:exec_new_window)
      }
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
      when :command
        run_command(node)

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
                :assign_variables, :runtime_value, :eval_functions
    attr_writer :result, :statement

    def load_parsed_line(statement)
      parser_statement = rebuild(JSON.load(statement))
      [parser_statement[0], parser_statement[1]]
    end

    def run_command(node)
      return commands[node.value].call(node) if commands.key?(node.value)

      msg = "Undefined command #{node.value}"
      ErrorMsg.new(parms: {
                     start_pos: node.start_pos,
                     line: node.line,
                     error_msg: msg
                   })
    end

    def exec_new_window(node)
      args = node.args.map do |arg|
        walk(arg)
      end
      args.each do |arg|
        return arg if arg.type == :error
      end

      unless new_window_valid_args?
        msg = 'One or more invalid arguments.'
        return evaluator_error(node, msg: msg)
      end

      # print "\e[5;5display: #{display.inspect}"
      # print "\e[6;5"

      display.new_window(name: '',
                         new_origin: win_origin(variables['origin'][:value]),
                         rows: variables['rows'][:value],
                         cols: variables['columns'][:value],
                         option: variables['type'][:value].to_sym)
      display.refresh_display

      msg = "#{node.value} executed."
      return_message(node, msg: msg)
    end

    def new_window_valid_args?
      # all arguments are variables
      win_types = %w[simple scrolling interactive]
      return false unless /\d+[;,|]\d+/.match?(variables['origin'][:value])
      return false unless variables['rows'][:value].is_a?(Integer)
      return false unless variables['columns'][:value].is_a?(Integer)
      return false unless win_types.include?(variables['type'][:value])

      true
    end

    def win_origin(value)
      # expect "1;1"
      [':', ',', '|'].each do |punc|
        value = value.sub(punc, ';')
      end
      value.split(';').map { |coord| coord.to_i }
    end

    def return_message(node, msg: nil)
      ReturnMessage.new(parms: {
                          type: :message,
                          line: node.line,
                          start_pos: node.start_pos,
                          msg: msg
                        })
    end

    def copy_error_message(node)
      ErrorMsg.new(parms: { type: node.type,
                            line: node.line,
                            start_pos: node.start_pos,
                            error_msg: node.error_msg })
    end
  end
end
