# frozen_string_literal: true

# project namespace
module CLIChess
  # create a new parser error node
  module NewErrorNode
    def new_error_node
      msg = tokens.current.name if tokens.current.type == :error
      ErrorNode.new(parms: {
                      type: :error,
                      line: tokens.current.line,
                      start_pos: tokens.current.col,
                      error_msg: msg
                    })
    end
  end
end
