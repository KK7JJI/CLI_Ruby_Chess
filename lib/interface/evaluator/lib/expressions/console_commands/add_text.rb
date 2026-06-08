# frozen_string_literal: true

# project namespace
module CLIChess
  # evaluator for keyword based command execution
  class AddText < ConsoleCommand
    include ErrorMessage
    include OutputMSG
    include ConsoleMixins

    ARGUMENT_NAMES = %w[name id file text option row col].freeze

    attr_accessor :window, :pattern, :row_col_opts

    def cont_initialize
      @argument_names = ARGUMENT_NAMES.map { |name| name }
      @window = nil
      @pattern = []
      @row_col_opts = {}
    end

    def add_text_switchboard
      {
        %w[ScrollingWindow] => handler,
        %w[SimpleWindow
           center_window] => handler(option: :center_in_window),
        %w[SimpleWindow center_row
           row] => handler(option: :center_in_row),
        %w[SimpleWindow justify_left
           row] => handler(option: :justify_left),
        %w[SimpleWindow justify_right
           row] => handler(option: :justify_right),
        %w[SimpleWindow insert_at row
           col] => handler(option: :insert_at)
      }
    end

    def handler(opts = {})
      lambda do |text|
        window.add_new_text(text, **opts, **row_col_opts)
      end
    end

    def initialize_arguments
      ARGUMENT_NAMES.each do |name|
        evaluator.variables.delete(name)
      end
    end

    def display_commands
      # need to add arguments

      filename = nil
      text = nil
      filename = evaluator.variables['file'][:value] if arg?('file')
      text = evaluator.variables['text'][:value] if arg?('text')

      window.show_file(filename) unless filename.nil?

      row_col_opts[:col] = evaluator.variables['col'][:value] if arg?('col')
      row_col_opts[:row] = evaluator.variables['row'][:value] if arg?('row')
      add_text_switchboard[pattern].call(text) unless text.nil?

      display.refresh_display
    end

    def window_identifier
      return nil unless valid_window_identifier?
      return evaluator.variables['name'][:value] if arg?('name')
      return evaluator.variables['id'][:value] if arg?('id')

      nil
    end

    def select_window(value)
      return display.select_window(value) unless value.nil?

      nil
    end

    def valid_args?
      return false unless valid_text_option?
      return false unless valid_name?
      return false unless valid_id?
      return false unless valid_option?

      true
    end

    def valid_option?
      self.window = select_window(window_identifier)
      pattern << classname(window)
      pattern << evaluator.variables['option'][:value] if arg?('option')
      pattern << 'row' if arg?('row')
      pattern << 'col' if arg?('col')
      return true if add_text_switchboard.key?(pattern)

      false
    end

    def classname(obj)
      obj.class.name.split('::').last
    end

    def valid_text_option?
      return false if %w[file text].all? do |key|
        evaluator.variables.key?(key)
      end
      return false unless %w[file text].any? do |key|
        evaluator.variables.key?(key)
      end

      true
    end

    def valid_window_identifier?
      return false if %w[name id].all? do |key|
        evaluator.variables.key?(key)
      end
      return false unless %w[name id].any? do |key|
        evaluator.variables.key?(key)
      end

      true
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

    def arg?(value)
      evaluator.variables.key?(value)
    end
  end
end
