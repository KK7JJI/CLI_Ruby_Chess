# frozen_string_literal: true

# project namespace
module CLIChess
  # evaluator for keyword based command execution
  class EvalConsoleCommands
    include ErrorMessage

    attr_reader :commands, :display, :evaluator

    def initialize(evaluator: nil, display: nil)
      @evaluator = evaluator
      @display = display

      @commands = {
        'new_window' => NewConsoleWindow,
        'list_windows' => ListWindows,
        'close_window' => CloseWindow,
        'activate_window' => ActivateWindow,
        'move_window' => MoveWindow,
        'refresh_display' => RefreshDisplay,
        'resize_window' => ResizeWindow
      }
    end

    def run_command(node)
      if commands.key?(node.value)
        return commands[node.value].call(evaluator: evaluator,
                                         display: display,
                                         node: node)
      end

      msg = "Undefined command #{node.value}"
      ErrorMsg.new(parms: {
                     start_pos: node.start_pos,
                     line: node.line,
                     error_msg: msg
                   })
    end
  end
end
