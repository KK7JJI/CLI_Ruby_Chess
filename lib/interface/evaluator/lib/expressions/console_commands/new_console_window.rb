# frozen_string_literal: true

# project namespace
module CLIChess
  # evaluator for keyword based command execution
  class NewConsoleWindow < ConsoleCommand
    include ErrorMessage

    ARGUMENT_NAMES = %w[name type origin cols rows].freeze

    def cont_initialize
      @argument_names = ARGUMENT_NAMES.map { |name| name }
    end

    def display_commands
      display.new_window(
        name: evaluator.variables['name'][:value],
        new_origin: win_origin(evaluator.variables['origin'][:value]),
        rows: evaluator.variables['rows'][:value],
        cols: evaluator.variables['cols'][:value],
        option: evaluator.variables['type'][:value].to_sym
      )
      display.refresh_display
    end

    def valid_args?
      # all arguments are evaluator.variables
      win_types = %w[simple scrolling interactive]
      unless /\d+[;,|]\d+/.match?(evaluator.variables['origin'][:value])
        return false
      end
      return false unless /^\w+$/.match?(evaluator.variables['name'][:value])
      return false unless evaluator.variables['rows'][:value].is_a?(Integer)
      return false unless evaluator.variables['cols'][:value].is_a?(Integer)
      unless win_types.include?(evaluator.variables['type'][:value])
        return false
      end

      true
    end
  end
end
