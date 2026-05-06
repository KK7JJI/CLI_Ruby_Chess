# frozen_string_literal: true

# project namespace
module CLIChess
  # evaluator binary operation
  module ErrorMessage
    def evaluator_error(node, msg: nil)
      parms = { start_pos: node.start_pos,
                line: node.line,
                error_msg: msg }
      ErrorMsg.new(parms: parms)
    end
  end
end
