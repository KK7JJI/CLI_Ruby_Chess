# frozen_string_literal: true

# project namespace
module CLIChess
  # recursive descent
  class Parser
    include Serialize

    attr_accessor :tokens, :parser_tree
    attr_reader :statement

    ASSIGNMENT_OPS = ['='].freeze
    MULTIPLICATIVE_OPS = ['*', '/', '%'].freeze
    UNARY_OPS = ['+', '-', '!'].freeze
    ADDITIVE_OPS = ['+', '-'].freeze
    COMPARISON_OPS = ['==', '!=', '<=', '>=', '<', '>'].freeze
    LOGICAL_AND_OPS = ['&&'].freeze
    LOGICAL_OR_OPS = ['||'].freeze
    VALUE_NODES = %i[integer string variable boolean].freeze

    BINARY_OP_TYPES = {
      additive: ADDITIVE_OPS,
      multiplicative: MULTIPLICATIVE_OPS,
      logical_or: LOGICAL_OR_OPS,
      logical_and: LOGICAL_AND_OPS,
      comparison: COMPARISON_OPS
    }.freeze

    PRIMARY_NODE_TYPES = {
      integer: IntegerNode,
      string: StringNode,
      boolean: BooleanNode,
      variable: VariableNode
    }.freeze

    def initialize
      @statement = nil
      @tokens = nil
      @parser_tree = nil
      @parser_trees = []
    end

    def pretty_print
      return parser_tree.pretty_print if parser_trees.empty?

      parser_trees.each do |parser_tree|
        if statement
          puts "statement: '#{parser_tree[0]}'"
          puts '=' * 20
        end
        parser_tree[1].pretty_print
        puts ''
      end
    end

    def parse_line(token_list: nil, statement: nil)
      return if token_list.empty?

      self.statement = statement
      self.tokens = token_list
      self.parser_tree = nil
      self.pos = 0

      self.parser_tree = parse_statement

      # if an error occured collape the parser tree
      # for the evaluator.
      if current&.type == :error
        self.parser_tree = error_node
      elsif !current.nil?
        self.parser_tree = unexpected_tokens
      end
    end

    # garbage collection, if we didn't process all tokens
    # then there was an error in the original expression.
    def unexpected_tokens
      msg = "SyntaxError, unexpected token \"#{current.name}\""
      insert_token(error_token(error_msg: msg))
      error_node
    end

    def parse_file_input(read_from: 'tokens.data', save_to: 'parser.data')
      File.open(read_from, 'r') do |file|
        file.each_line do |input_line|
          load_tokens(input_line)
          parse_line(token_list: tokens, statement: statement)
          parser_trees << [statement, parser_tree]
        end
      end
      save_parser_trees(save_to: save_to)
    end

    def load_tokens(input_line)
      # load tokens serialized by the tokenizer.
      token_list = rebuild(JSON.load(input_line))
      token_list[1].each do |token|
        token.type = token.type.to_sym
      end
      self.statement = token_list[0].chomp
      self.tokens = token_list[1]
    end

    def save_parser_trees(save_to:)
      # serialize parser trees and save them to file.
      File.open(save_to, 'w') do |file|
        parser_trees.each do |parser_tree|
          file.puts JSON.generate(parser_tree)
        end
      end
    end

    private

    attr_accessor :pos, :lines, :parser_trees
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

    def advance_to_end
      self.pos = tokens.length - 1
    end

    def insert_token(token)
      tokens[pos] = token
      # self.tokens = tokens[0, pos] + [token] + tokens[pos, tokens.length - 1]
    end

    def consume(expected_type: nil, expected_value: nil)
      if current.nil?
        # ran out of tokens prematurely.
        insert_token(error_token(
                       error_msg: 'SyntaxError, unexpected end of line',
                       position_offset: 1
                     ))
        return
      end

      if parse_error?(expected_type, expected_value)
        msg = "SyntaxError: unexpected token type \"#{current.type}\", " \
              "value \"#{current.name}\""
        insert_token(error_token(error_msg: msg))
        return
      end

      advance
    end

    def parse_error?(expected_type, expected_value)
      return true unless expected_type?(expected_type)
      return true unless expected_value?(expected_value)

      false
    end

    def expected_type?(type = nil)
      return true if type.nil?

      type.any?(current.type)
    end

    def expected_value?(value = nil)
      return true if value.nil?

      value.any?(current.name)
    end

    def parse_statement
      # process keywords here as well.
      return parse_command if current.type == :keyword
      return parse_assignment if variable_assignment?

      parse_expression
    end

    def parse_command
      return unless current&.type == :keyword && current&.name == 'new_window'

      command_new_window
    end

    def command_node(token, args = [])
      CommandNode.new(parms: {
                        type: :command,
                        value: token.name,
                        args: args,
                        line: token.line,
                        start_pos: token.col
                      })
    end

    def command_new_window
      # new_window type='simple', origin='1;1', columns=30, rows=20
      token = current
      consume(expected_type: [:keyword], expected_value: ['new_window'])
      cmd_node = command_node(token)

      var_names = %w[type origin columns rows]

      var_name = current&.name if current&.type == :variable
      cmd_node.args << parse_assignment(var_names: var_names)
      var_names.delete(var_name)

      while current&.type == :punctuation && current&.name == ','
        consume(expected_type: [:punctuation], expected_value: [','])
        var_name = current.name if current&.type == :variable
        cmd_node.args << parse_assignment(var_names: var_names)
        var_names.delete(var_name)
      end

      var_names = var_names.map { |name| "\"#{name}\"" }
      msg = "\"#{cmd_node.value}\" missing arguments #{var_names.join(', ')}"
      insert_token(error_token(error_msg: msg)) unless var_names.empty?

      return cmd_node unless current&.type == :error

      insert_token(error_token(error_msg: msg))
      error_node
    end

    def variable_assignment?
      return false unless current.type == :variable
      return false unless peek_next
      return false unless peek_next.type == :assignment

      true
    end

    def parse_assignment(var_names: nil)
      # a = 2
      # var_names -> list of allowed names, optional
      token = current # variable
      consume(expected_type: %i[variable], expected_value: var_names)
      consume(expected_type: %i[assignment], expected_value: ['='])

      unless current&.type == :error
        return assignment_node(token,
                               parse_expression)
      end

      error_node
    end

    def assignment_node(token, node)
      AssignmentNode.new(parms: {
                           line: token.line,
                           start_pos: token.col,
                           value: token.name,
                           assigned_node: node
                         })
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

    def binary_operator?(op_type)
      return false if current.nil?
      return false unless %i[operator comparison].include?(current.type)
      return false unless BINARY_OP_TYPES[op_type].include?(current.name)

      true
    end

    def parse_binary(callback, op_type)
      node = callback.call
      while binary_operator?(op_type)
        token = current
        consume(expected_type: %i[operator comparison])
        right_node = callback.call
        node = binary_node(token, node, right_node)
      end
      node
    end

    def binary_node(token, left_node, right_node)
      BinaryOpNode.new(parms: {
                         line: token.line,
                         start_pos: token.col,
                         value: token.name,
                         left_node: left_node,
                         right_node: right_node
                       })
    end

    def parse_unary
      # -5
      return parse_primary unless unary_operator?

      # advance past the operator token
      token = current
      consume(expected_type: %i[operator logical])

      unary_node(token, parse_unary)
    end

    def unary_operator?
      return false if current.nil?
      return false unless %i[operator logical].include?(current.type)
      return false unless UNARY_OPS.include?(current.name)

      true
    end

    def unary_node(token, node)
      UnaryOpNode.new(parms: {
                        line: token.line,
                        start_pos: token.col,
                        value: token.name,
                        node: node
                      })
    end

    def parse_primary
      unless current.nil?
        return function if function?

        %i[integer string boolean variable].each do |type|
          next unless current.type == type

          return primary_value_node(type)
        end

        return expression_group if expression_group?
      end

      # we are either out of tokens or one has made
      # its way here which doesn't belong here.
      msg = 'SyntaxError, incomplete expression.'
      insert_token(error_token(error_msg: msg))
      error_node
    end

    def function
      token = current
      consume(expected_type: [:variable])
      consume(expected_type: [:punctuation], expected_value: ['('])

      args = function_args
      consume(expected_type: [:punctuation], expected_value: [')'])
      function_node(token, args)
    end

    def function_args
      return [] if current.nil?
      return [] if current.name == ')' && current.type == :punctuation

      args = []
      args << parse_expression
      while current && current.type == :punctuation && current.name == ','
        consume(expected_type: [:punctuation], expected_value: [','])
        args << parse_expression
      end
      args
    end

    def function_node(token, args)
      FunctionNode.new(parms: {
                         type: :function,
                         line: token.line,
                         start_pos: token.col,
                         func: token.name,
                         args: args
                       })
    end

    def function?
      return false if current.nil?
      return false unless current.type == :variable
      return false unless peek_next
      return false unless peek_next.type == :punctuation
      return false unless peek_next.name == '('

      true
    end

    def expression_group
      consume(expected_type: %i[punctuation], expected_value: ['('])
      expr = parse_expression
      return expr if expr.type == :error

      consume(expected_type: %i[punctuation], expected_value: [')'])
      expr
    end

    def expression_group?
      return false if current.nil?
      return false unless current.type == :punctuation
      return false unless current.name == '('

      true
    end

    def primary_value_node(type)
      token = current
      consume(expected_type: [type])

      PRIMARY_NODE_TYPES[type].new(parms: {
                                     line: token.line,
                                     start_pos: token.col,
                                     value: token.name
                                   })
    end

    def error_token(error_msg: nil, position_offset: 0)
      token = current || tokens[-1]
      Token.new(
        type: :error,
        name: error_msg,
        line: token.line,
        col: token.col + position_offset
      )
    end

    def error_node
      msg = current.name if current.type == :error
      ErrorNode.new(parms: {
                      type: :error,
                      line: current.line,
                      start_pos: current.col,
                      error_msg: msg
                    })
    end
  end
end
