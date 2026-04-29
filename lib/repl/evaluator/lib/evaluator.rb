# frozen_string_literal: true

# namespace for the project
module CLIChess
  # evaluate parser nodes
  class Evaluator
    include Serialize

    attr_reader :variables, :result, :statement

    def initialize
      @variables = {}
      @result = nil
      @statement = nil
    end

    def evaluate_line(parser_root: nil, statement: nil)
      return if parser_root.nil?

      self.statement = statement
      self.result = walk(parser_root)
      puts self
      puts ''
    end

    def evaluate_file_input(read_from: 'parser.data')
      File.open(read_from, 'r') do |file|
        file.each_line do |input_line|
          statement, root = load_parsed_line(input_line)
          evaluate_line(parser_root: root, statement: statement)
        end
      end
    end

    def to_s
      "Statement: #{statement}\nResult=#{result}"
    end

    private

    attr_writer :result, :statement

    def load_parsed_line(statement)
      parser_root = rebuild(JSON.load(statement))
      [parser_root[0], parser_root[1]]
    end

    def walk(node)
      node.type = node.type.to_sym
      if %i[assignment].include?(node.type)
        set_variable(node)

      elsif [:binary].include?(node.type)

        binary_operations(
          node.value,
          walk(node.left_node),
          walk(node.right_node)
        )

      elsif %i[unary].include?(node.type)
        unary_operations(
          node.value,
          walk(node.node)
        )

      elsif %i[boolean integer string].include?(node.type)
        runtime_value(node)

      elsif %i[variable].include?(node.type)
        resolve_variable(node)

      else
        puts "#{node.type}, #{node.type.class}"
        raise NotImplementedError, node
      end
    end

    def runtime_value(node)
      parms = { value: node.value, start_pos: node.start_pos,
                line: node.line }
      return IntegerValue.new(parms: parms) if node.type == :integer
      return StringValue.new(parms: parms) if node.type == :string
      return BooleanValue.new(parms: parms) if node.type == :boolean

      raise "undefined value type #{node.type}, pos #{start_pos}"
    end

    def set_variable(node)
      result = walk(node.assigned_node)
      variables[node.value] =
        { value: result.value, type: result.class.name }
      result
    end

    def resolve_variable(node)
      unless variables.key?(node.name)
        raise NameError,
              "undefined variable \"#{node.name}\", pos: #{node.start_pos}"
      end

      parms = { value: variables[node.name][:value], start_pos: node.start_pos,
                line: node.line }

      return IntegerValue.new(parms: parms) \
        if variables[node.name][:type] == :integer
      return StringValue.new(parms: parms) \
        if variables[node.name][:type] == :string
      return BooleanValue.new(parms: parms) \
        if variables[node.name][:type] == :boolean

      raise "undefined value type for variable \"#{node.name}\", " \
            "type #{node.type} pos: #{node.start_pos}"
    end

    def unary_operations(operator, value)
      ops = {
        '!' => ->(x) { !x },
        '-' => ->(x) { -x },
        '+' => ->(x) { +x }
      }

      ops[operator].call(value)
    end

    def binary_operations(operator, l_value, r_value)
      ops = {
        '+' => ->(x, y) { x + y },
        '-' => ->(x, y) { x - y },
        '*' => ->(x, y) { x * y },
        '/' => ->(x, y) { x / y },
        '%' => ->(x, y) { x % y },
        '==' => ->(x, y) { x == y },
        '!=' => ->(x, y) { x != y },
        '>=' => ->(x, y) { x >= y },
        '<=' => ->(x, y) { x <= y },
        '<' => ->(x, y) { x < y },
        '>' => ->(x, y) { x > y }
      }

      ops[operator].call(l_value, r_value)
    end
  end
end
