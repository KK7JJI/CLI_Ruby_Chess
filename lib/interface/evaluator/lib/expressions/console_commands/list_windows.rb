# frozen_string_literal: true

# project namespace
module CLIChess
  # evaluator for keyword based command execution
  class ListWindows < ConsoleCommand
    include ErrorMessage
    include OutputMSG
    include ConsoleMixins

    def display_commands
      display.list_windows
      display.refresh_display
    end

    def valid_args?
      true
    end
  end
end
