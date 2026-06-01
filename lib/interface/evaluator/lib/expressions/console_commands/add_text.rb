# frozen_string_literal: true

# project namespace
module CLIChess
  # evaluator for keyword based command execution
  class AddText < ConsoleCommand
    include ErrorMessage
    include OutputMSG
    include ConsoleMixins

    ARGUMENT_NAMES = %w[name id file text option].freeze

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
      value = nil
      window = nil
      value = evaluator.variables['name'][:value] if arg?('name')
      value = evaluator.variables['id'][:value] if arg?('id')
      window = display.select_window(value) unless value.nil?
      return nil if window.nil?

      filename = nil
      text = nil
      filename = evaluator.variables['file'][:value] if arg?('file')
      text = evaluator.variables['text'][:value] if arg?('text')

      window.show_file(filename) unless filename.nil?
      window.add_new_text(text) unless text.nil?

      display.refresh_display
    end

    def valid_args?
      return false unless %w[name id].any? do |key|
        evaluator.variables.key?(key)
      end
      return false unless %w[file text].any? do |key|
        evaluator.variables.key?(key)
      end
      return false unless valid_name?
      return false unless valid_id?

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
