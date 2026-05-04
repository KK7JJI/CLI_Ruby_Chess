# frozen_string_literal: true

# namespace for the project
module CLIChess
  VALUE_CLASSES = {
    integer: IntegerValue,
    string: StringValue,
    boolean: BooleanValue
  }.freeze

  UNARY_METHODS = {
    '+' => :+@,
    '-' => :-@,
    '!' => :!
  }.freeze

  # evaluate parser nodes
  class Evaluator
    include Serialize

    attr_reader :variables, :result, :statement, :functions

    def initialize
      @variables = {}
      @result = nil
      @statement = nil
      @functions = {
        'add_ints' => method(:func_add_ints),
        'prod_ints' => method(:func_prod_ints),
        'factorial' => method(:func_factorial)
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
    end

    def inspect
      "Statement: #{statement}\nResult=#{result}"
    end

    def to_s
      result
    end

    private

    attr_writer :result, :statement

    def load_parsed_line(statement)
      parser_statement = rebuild(JSON.load(statement))
      [parser_statement[0], parser_statement[1]]
    end

    def walk(node)
      type = node.type.to_sym

      case type
      when :assignment
        set_variable(node)

      when :function
        evaluate_function_call(node)

      when :binary
        binary_operations(
          node.value,
          walk(node.left_node),
          walk(node.right_node)
        )

      when :unary
        unary_operations(
          node.value,
          walk(node.node)
        )

      when :boolean, :string, :integer
        runtime_value(node)

      when :variable
        resolve_variable(node)

      when :error
        copy_error_message(node)

      else
        evaluator_error(node,
                        msg: "evaluation not implemented for type \"#{type}\"")
      end
    end

    def evaluator_error(node, msg: nil)
      parms = { start_pos: node.start_pos,
                line: node.line,
                error_msg: msg }
      ErrorMsg.new(parms: parms)
    end

    def evaluate_function_call(node)
      return functions[node.func].call(node) if functions.key?(node.func)

      msg = "Undefined function #{func}"
      ErrorMsg.new(parms: {
                     start_pos: node.start_pos,
                     line: node.line,
                     error_msg: msg
                   })
    end

    def func_prod_ints(node)
      args = arg_values(node)
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

    def func_add_ints(node)
      args = arg_values(node)
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

    def func_factorial(node)
      args = arg_values(node)
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

    def arg_values(node)
      node.args.map do |arg|
        walk(arg).value
      end
    end

    def runtime_value(node)
      type = node.type.to_sym
      parms = { type: type, value: node.value, start_pos: node.start_pos,
                line: node.line }
      return IntegerValue.new(parms: parms) if type == :integer
      return StringValue.new(parms: parms) if type == :string
      return BooleanValue.new(parms: parms) if type == :boolean

      evaluator_error(node, msg: "undefined value type #{type}")
    end

    def set_variable(node)
      result = walk(node.assigned_node)
      variables[node.value] =
        { value: result.value, type: result.type }
      result
    end

    def resolve_variable(node)
      unless variables.key?(node.value)
        return evaluator_error(node,
                               msg: "undefined variable \"#{node.value}\"")
      end

      parms = { value: variables[node.value][:value],
                start_pos: node.start_pos,
                line: node.line }

      klass = VALUE_CLASSES[variables[node.value][:type]]
      if klass
        return klass.new(parms: parms.merge(
          type: variables[node.value][:type]
        ))
      end

      msg = "undefined value type for variable \"#{node.value}\", " \
            "type \"#{node.type}\""
      evaluator_error(node, msg: msg)
    end

    def unary_operations(operator, value)
      method = UNARY_METHODS[operator]
      unless value.respond_to?(method)
        msg = "Operator \"#{method}\" not supported for #{value.type}"
        return evaluator_error(value, msg: msg)
      end
      value.public_send(method)
    end

    def binary_operations(operator, l_value, r_value)
      unless l_value.respond_to?(operator)
        msg = "Operator \"#{method}\" not supported for #{l_value.type}"
        return evaluator_error(l_value, msg: msg)
      end
      l_value.public_send(operator, r_value)
    end

    def copy_error_message(node)
      parms = { type: node.type,
                line: node.line,
                start_pos: node.start_pos,
                error_msg: node.error_msg }
      ErrorMsg.new(parms: parms)
    end
  end
end
