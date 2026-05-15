# frozen_string_literal: true

# project namespace
module CLIChess
  # recursive descent
  class Parser
    include Serialize
    include NewErrorNode

    attr_accessor :parser_tree
    attr_reader :statement, :consume, :tokens, :assignment, :function, :command

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
      @parser_tree = nil
      @parser_trees = []

      @tokens = TokenList.new
      @consume = Consume.new(tokens: @tokens)

      @parms = {
        parser: self,
        consume: @consume,
        tokens: @tokens
      }

      @assignment = Assignment.new(parms: @parms)
      @function = Function.new(parms: @parms)
      @command = Command.new(parms: @parms.merge({ assignment: @assignment }))
    end

    def pretty_print
      return parser_tree.pretty_print if parser_trees.empty?

      parser_trees.each do |parser_tree|
        if tokens.statement
          puts "statement: '#{parser_tree[0]}'"
          puts '=' * 20
        end
        parser_tree[1].pretty_print
        puts ''
      end
    end

    def parse_line(token_list: nil, statement: nil)
      return if token_list.empty?

      tokens.load_list(statement, token_list)
      self.parser_tree = nil

      self.parser_tree = parse_statement

      # if an error occured collape the parser tree
      # for the evaluator.
      if tokens.current&.type == :error
        self.parser_tree = new_error_node
      elsif !tokens.current.nil?
        self.parser_tree = unexpected_tokens
      end
    end

    # garbage collection, if we didn't process all tokens
    # then there was an error in the original expression.
    def unexpected_tokens
      msg = "SyntaxError, unexpected token \"#{tokens.current.name}\""
      tokens.insert_token(tokens.error_token(error_msg: msg))
      new_error_node
    end

    def parse_file_input(read_from: 'tokens.data', save_to: 'parser.data')
      File.open(read_from, 'r') do |file|
        file.each_line do |input_line|
          tokens.load_tokens(input_line)
          parse_line(token_list: tokens.tokens, statement: tokens.statement)
          parser_trees << [tokens.statement, parser_tree]
        end
      end
      save_parser_trees(save_to: save_to)
    end

    def parse_new_expression
      parse_expression
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

    def parse_statement
      command_node = command.parse_command
      return command_node unless command_node.nil?

      assignment_node = assignment.parse_assignment
      return assignment_node unless assignment_node.nil?

      parse_expression
    end

    # def parse_command
    #   unless tokens.current&.type == :keyword && tokens.current&.name == 'new_window'
    #     return
    #   end

    #   command_new_window
    # end

    # def command_node(token, type, args = [])
    #   CommandNode.new(parms: {
    #                     type: type,
    #                     value: token.name,
    #                     args: args,
    #                     line: token.line,
    #                     start_pos: token.col
    #                   })
    # end

    # def command_new_window
    #   # new_window type='simple', origin='1;1', columns=30, rows=20
    #   token = tokens.current
    #   consume.consume(expected_type: [:keyword], expected_value: ['new_window'])
    #   cmd_node = command_node(token, :console_command)

    #   # var_names -> user supplied arguments, type, origin, columns, rows
    #   # each occurs only one time.
    #   var_names = %w[type origin columns rows]

    #   var_name = tokens.current&.name if tokens.current&.type == :variable
    #   cmd_node.args << assignment.parse_assignment(var_names: var_names)
    #   var_names.delete(var_name)

    #   while tokens.current&.type == :punctuation && tokens.current&.name == ','
    #     consume.consume(expected_type: [:punctuation], expected_value: [','])
    #     var_name = tokens.current.name if tokens.current&.type == :variable
    #     cmd_node.args << assignment.parse_assignment(var_names: var_names)
    #     var_names.delete(var_name)
    #   end

    #   var_names = var_names.map { |name| "\"#{name}\"" }
    #   msg = "\"#{cmd_node.value}\" missing arguments #{var_names.join(', ')}"
    #   unless var_names.empty?
    #     tokens.insert_token(tokens.error_token(error_msg: msg))
    #   end

    #   return cmd_node unless tokens.current&.type == :error

    #   tokens.insert_token(tokens.error_token(error_msg: msg))
    #   new_error_node
    # end

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
      return false if tokens.current.nil?
      return false unless %i[operator comparison].include?(tokens.current.type)
      return false unless BINARY_OP_TYPES[op_type].include?(tokens.current.name)

      true
    end

    def parse_binary(callback, op_type)
      node = callback.call
      while binary_operator?(op_type)
        token = tokens.current
        consume.consume(expected_type: %i[operator comparison])
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
      token = tokens.current
      consume.consume(expected_type: %i[operator logical])

      unary_node(token, parse_unary)
    end

    def unary_operator?
      return false if tokens.current.nil?
      return false unless %i[operator logical].include?(tokens.current.type)
      return false unless UNARY_OPS.include?(tokens.current.name)

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
      unless tokens.current.nil?
        function_node = function.new_function_node
        return function_node unless function_node.nil?

        %i[integer string boolean variable].each do |type|
          next unless tokens.current.type == type

          return primary_value_node(type)
        end

        return expression_group if expression_group?
      end

      # we are either out of tokens or one has made
      # its way here which doesn't belong here.
      msg = 'SyntaxError, incomplete expression.'
      tokens.insert_token(tokens.error_token(error_msg: msg))
      new_error_node
    end

    def expression_group
      consume.consume(expected_type: %i[punctuation], expected_value: ['('])
      expr = parse_expression
      return expr if expr.type == :error

      consume.consume(expected_type: %i[punctuation], expected_value: [')'])
      expr
    end

    def expression_group?
      return false if tokens.current.nil?
      return false unless tokens.current.type == :punctuation
      return false unless tokens.current.name == '('

      true
    end

    def primary_value_node(type)
      token = tokens.current
      consume.consume(expected_type: [type])

      PRIMARY_NODE_TYPES[type].new(parms: {
                                     line: token.line,
                                     start_pos: token.col,
                                     value: token.name
                                   })
    end
  end
end
