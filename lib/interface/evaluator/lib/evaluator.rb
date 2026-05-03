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
    '!' => :! # only works if you override `!`
  }.freeze

  # evaluate parser nodes
  class Evaluator
    include Serialize

    attr_reader :variables, :result, :statement

    def initialize
      @variables = {}
      @result = nil
      @statement = nil
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
