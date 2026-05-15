# frozen_string_literal: true

# project namespace
module CLIChess
  # create a new parser error node
  module NewCommandNode
    def new_command_node(token, type, args = [])
      CommandNode.new(parms: {
                        type: type,
                        value: token.name,
                        args: args,
                        line: token.line,
                        start_pos: token.col
                      })
    end
  end
end
