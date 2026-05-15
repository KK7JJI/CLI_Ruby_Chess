# frozen_string_literal: true

# project namespace
module CLIChess
  # assign value to a variable
  class Assignment
    include NewErrorNode

    attr_reader :tokens, :consume, :parser

    def initialize(parms:)
      @tokens = parms[:tokens]
      @consume = parms[:consume]
      @parser = parms[:parser]
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

      new_error_node
    end

    def variable_assignment?
      return false if tokens.current.nil?
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
