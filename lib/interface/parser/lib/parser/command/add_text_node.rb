# frozen_string_literal: true

# project namespace
module CLIChess
  # process command new_window
  class AddTextNode < WindowNode
    ALLOWED_NAMES = %w[name id file text option row col].freeze
    REQUIRED_NAMES = [].freeze

    def cont_initialize(parms:)
      @required_args = true
      @mandatory_args = REQUIRED_NAMES.map { |item| item }
      @allowed_args = ALLOWED_NAMES.map { |item| item }
    end

    def run
      self.cmd_node = new_command_node(tokens.current, :console_command)
      consume.consume(expected_type: [:keyword], expected_value: ['add_text'])
      add_command_arguments

      return error_node unless valid_command_node?

      cmd_node
    end

    def valid_command_node?
      return false if tokens.current && tokens.current.type == :error
      return false unless mandatory_args.empty?
      return false unless valid_args?

      var_names = cmd_node.args.map { |arg| arg.value }
      return !var_names.empty? if required_args
      return false if %w[name id].all? { |name| var_names.include?(name) }
      return false if %w[name id].none? { |name| var_names.include?(name) }
      return false if %w[file text].all? { |name| var_names.include?(name) }
      return false if %w[file text].none? { |name| var_names.include?(name) }

      true
    end
  end
end
