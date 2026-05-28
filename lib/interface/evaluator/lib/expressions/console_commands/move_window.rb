# frozen_string_literal: true

# project namespace
module CLIChess
  # evaluator for keyword based command execution
  class MoveWindow < ConsoleCommand
    include ErrorMessage
    include OutputMSG
    include ConsoleMixins

    ARGUMENT_NAMES = %w[name id loc].freeze

    def cont_initialize
      @argument_names = ARGUMENT_NAMES.map { |name| name }
    end

    def initialize_arguments
      ARGUMENT_NAMES.each do |name|
        evaluator.variables.delete(name)
      end
    end

    def display_commands
      # need to add arguments
      location = win_origin(evaluator.variables['loc'][:value])
      value = evaluator.variables['name'][:value] if arg?('name')
      value = evaluator.variables['id'][:value] if arg?('id')
      display.move_window(value, location)
      display.refresh_display
    end

    def valid_args?
      return false unless %w[name id].any? do |key|
        evaluator.variables.key?(key)
      end
      return false unless evaluator.variables.key?('loc')
      return false unless valid_name?
      return false unless valid_id?

      unless /^\d+[;:,|]\d+$/.match?(evaluator.variables['loc'][:value])
        return false
      end

      true
    end

    def arg?(value)
      evaluator.variables.key?(value)
    end

    def valid_name?
      return true unless arg?('name')
      return false unless /^\w+$/.match?(evaluator.variables['name'][:value])

      true
    end

    def valid_id?
      return true unless arg?('id')
      return false unless evaluator.variables['id'][:value].is_a?(Integer)

      true
    end
  end
end
