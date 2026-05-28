# frozen_string_literal: true

# project namespace
module CLIChess
  # evaluator for keyword based command execution
  class ActivateWindow < ConsoleCommand
    include ErrorMessage
    include OutputMSG
    include ConsoleMixins

    ARGUMENT_NAMES = %w[name id].freeze

    def cont_initialize
      @argument_names = ARGUMENT_NAMES.map { |name| name }
    end

    def display_commands
      display.activate_window(args[0].value)
      display.refresh_display
    end

    def valid_args?
      # arguments can be:
      # variable name
      # variable id
      # integer
      # string
      return false if args.empty?

      true
    end
  end
end
