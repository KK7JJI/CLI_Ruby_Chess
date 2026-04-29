# frozen_string_literal: true

# project namespace
module CLIChess
  # recursive descent
  class Parser
    include Serialize

    attr_accessor :tokens, :root
    attr_reader :statement

    ASSIGNMENT_OPS = ['='].freeze
    MULTIPLICATIVE_OPS = ['*', '/', '%'].freeze
    UNARY_OPS = ['+', '-', '!'].freeze
    ADDITIVE_OPS = ['+', '-'].freeze
    COMPARISON_OPS = ['==', '!=', '<=', '>=', '<', '>'].freeze
    LOGICAL_AND_OPS = ['&&'].freeze
    LOGICAL_OR_OPS = ['||'].freeze
    VALUE_NODES = %i[integer string variable boolean].freeze

    def initialize
      @statement = nil
      @tokens = nil
      @root = nil
      @parser_roots = []
      @line = 0
      @pos = 0
      @script_file = nil
    end

    def pretty_print
      return root.pretty_print if parser_roots.empty?

      parser_roots.each do |root|
        if statement
          puts "statement: '#{root[0]}'"
          puts '=' * 20
        end
        root[1].pretty_print
        puts ''
      end
    end

    def parse_line(token_list: nil, statement: nil)
      self.statement = statement
      self.tokens = token_list
      self.root = parse_statement
      return if current.nil?

      # extra tokens left over.
      raise SyntaxError,
            "unexpected token \"#{current.name}\"" \
            ", got #{current.name} line: #{current.line} (#{current.col})"
    end

    def parse_file_input(read_from: 'tokens.data', save_to: 'parser.data')
      File.open(read_from, 'r') do |file|
        file.each_line do |input_line|
          self.root = nil
          self.pos = 0
          load_tokens(input_line)
          parse_line(token_list: tokens, statement: statement)
          parser_roots << [statement, root]
        end
      end
      save_parser_roots(save_to: save_to)
    end

    def load_tokens(input_line)
      token_list = rebuild(JSON.load(input_line))
      token_list[1].each do |token|
        token.type = token.type.to_sym
      end
      self.statement = token_list[0].chomp
      self.tokens = token_list[1]
    end

    def save_parser_roots(save_to:)
      File.open(save_to, 'w') do |file|
        parser_roots.each do |root|
          file.puts JSON.generate(root)
        end
      end
    end

    private

    attr_accessor :pos, :lines, :parser_roots
    attr_writer :statement

    def current
      tokens[pos]
    end

    def peek_next
      tokens[pos + 1]
    end

    def advance
      self.pos += 1
    end

    def consume(expected_type, expected_value = nil) # rubocop:disable Metrics/MethodLength
      unless expected_type?(expected_type)
        raise SyntaxError,
              "Expected: #{expected_type}" /
              ", got #{current.type} line: #{current.line} (#{current.col})"
      end

      unless expected_value?(expected_value)
        raise SyntaxError,
              "Expected: #{expected_value}" \
              ", got #{current.name} line: #{current.line} (#{current.col})"
      end

      advance
    end

    def expected_type?(expected_type = nil)
      return true if expected_type.nil?

      expected_type.any?(current.type)
    end

    def expected_value?(value = nil)
      return true if value.nil?

      value == current.name
    end

    def parse_statement
      if current.type == :variable && peek_next.type == :assignment
        parse_assignment
      else
        parse_expression
      end
    end

    def parse_assignment
      token = current # variable
      consume(%i[variable])
      consume(%i[assignment])
      node = parse_expression
      assignment_node(token, node)
    end

    def assignment_node(token, node)
      node_parms = {
        line: token.line,
        start_pos: token.col,
        value: token.name,
        assigned_node: node
      }
      AssignmentNode.new(parms: node_parms)
    end

    def parse_expression
      parse_logical_or
    end

    def parse_logical_or
      parse_binary(method(:parse_logical_and), :logical_or)
    end

    def parse_logical_and
      parse_binary(method(:parse_comparison), :logical_and)
    end

    def parse_comparison
      parse_binary(method(:parse_additive), :comparison)
    end

    def parse_additive
      parse_binary(method(:parse_multiplicative), :additive)
    end

    def parse_multiplicative
      parse_binary(method(:parse_unary), :multiplicative)
    end

    def parse_binary(callback, op_type)
      node = callback.call
      while current && %i[operator comparison].include?(current.type) \
                    && op_list(op_type).include?(current.name)
        token = current
        advance
        right_node = callback.call
        node = binary_node(token, node, right_node)
      end
      node
    end

    def op_list(op_type)
      case op_type
      when :additive then ADDITIVE_OPS
      when :multiplicative then MULTIPLICATIVE_OPS
      when :logical_or then LOGICAL_OR_OPS
      when :logical_and then LOGICAL_AND_OPS
      when :comparison then COMPARISON_OPS
      end
    end

    def binary_node(token, left_node, right_node)
      node_parms = {
        line: token.line,
        start_pos: token.col,
        value: token.name,
        left_node: left_node,
        right_node: right_node
      }
      BinaryOpNode.new(parms: node_parms)
    end

    def parse_unary # rubocop:disable Metrics/MethodLength
      token = current
      if token && %i[operator
                     logical].include?(
                       token.type
                     ) && UNARY_OPS.include?(token.name)
        advance
        node = parse_unary
        unary_node(token, node)
      else
        parse_primary
      end
    end

    def unary_node(token, node)
      node_parms = {
        line: token.line,
        start_pos: token.col,
        value: token.name,
        node: node
      }
      UnaryOpNode.new(parms: node_parms)
    end

    def parse_primary
      token = current

      if token.nil?
        raise SyntaxError, 'Unexpected end of line.' \
                           ", line: #{current.line}"
      end

      %i[integer string boolean variable].each do |type|
        next unless token.type == type

        consume([type], nil)
        return primary_value_node(type, token)
      end

      # start a new expression
      return primary_expression if token.type ==
                                   :punctuation && token.name == '('

      raise SyntaxError, "unexpected token \"#{token.name}\"" \
                         ", line: #{token.line} (#{token.col})"
    end

    def primary_value_node(type, token)
      node_parms = {
        line: token.line,
        start_pos: token.col,
        value: token.name
      }
      return IntegerNode.new(parms: node_parms) if type == :integer
      return StringNode.new(parms: node_parms) if type == :string
      return BooleanNode.new(parms: node_parms) if type == :boolean

      VariableNode.new(parms: node_parms)
    end

    def primary_expression
      consume(%i[punctuation], '(')
      expr = parse_expression
      consume(%i[punctuation], ')')
      expr
    end
  end
end
