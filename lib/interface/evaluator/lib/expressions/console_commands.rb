# frozen_string_literal: true

# project namespace
module CLIChess
  # evaluator for keyword based command execution
  class EvalConsoleCommands
    include ErrorMessage

    attr_reader :commands, :display

    def initialize(evaluator: nil, display: nil)
      @evaluator = evaluator
      @display = display

      @new_console_window = NewConsoleWindow.new(
        evaluator: @evaluator, display: @display
      )

      @commands = {
        'new_window' => @new_console_window.method(:exec_new_window)
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
  end
end
