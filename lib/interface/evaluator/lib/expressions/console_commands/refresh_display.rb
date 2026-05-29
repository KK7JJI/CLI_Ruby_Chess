# frozen_string_literal: true

# project namespace
module CLIChess
  # evaluator for keyword based command execution
  class RefreshDisplay < ConsoleCommand
    include ErrorMessage
    include OutputMSG
    include ConsoleMixins

    def display_commands
      display.refresh_display
    end

    def valid_args?
      true
    end
  end
end
