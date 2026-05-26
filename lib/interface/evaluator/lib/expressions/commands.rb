# frozen_string_literal: true

# project namespace
module CLIChess
  # evaluator for keyword based command execution
  class EvalCommands
    include ErrorMessage

    attr_reader :commands

    def initialize(evaluator: nil)
      @evaluator = evaluator

      @commands = {
        'no_method' => method(:do_nothing)
      }
    end

    def run_command(node)
      return commands[node.value].call(node) if commands.key?(node.value)

      msg = "Undefined command #{node.value}"
      ErrorMsg.new(parms: {
                     start_pos: node.start_pos,
                     line: node.line,
                     error_msg: msg
                   })
    end

    def do_nothing
    end
  end
end
