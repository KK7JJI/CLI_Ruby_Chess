# frozen_string_literal: true

# project namespace
module CLIChess
  # consume methods, used in recursive descent
  class Assignment
    include NewErrorNode

    attr_reader :tokens, :consume, :parser

    def initialize(parser: nil, consume: nil, tokens: nil)
      @tokens = tokens
      @consume = consume
      @parser = parser
    end

    def parse_assignment(var_names: nil)
      # a = 2
      # var_names -> list of allowed names, optional
      return nil unless variable_assignment?

      token = tokens.current # variable
      consume.consume(expected_type: %i[variable], expected_value: var_names)
      consume.consume(expected_type: %i[assignment], expected_value: ['='])

      unless tokens.current&.type == :error
        return assignment_node(token,
                               parser.parse_new_expression)
      end

      error_node
    end

    def variable_assignment?
      return false unless tokens.current.type == :variable
      return false unless tokens.peek_next
      return false unless tokens.peek_next.type == :assignment

      true
    end

    def assignment_node(token, node)
      AssignmentNode.new(parms: {
                           line: token.line,
                           start_pos: token.col,
                           value: token.name,
                           assigned_node: node
                         })
    end
  end
end
