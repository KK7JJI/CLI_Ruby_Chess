# frozen_string_literal: true

# project namespace
module CLIChess
  # process command new_window
  class ResizeWindowNode < WindowNode
    MANDATORY_ARGS = %w[rows cols].freeze
    ARGUMENT_NAMES = %w[name id rows cols].freeze

    def cont_initialize(parms:)
      @required_args = true
      @mandatory_args = MANDATORY_ARGS.map { |item| item }
      @allowed_args = ARGUMENT_NAMES.map { |item| item }
    end

    def run
      self.cmd_node = new_command_node(tokens.current, :console_command)
      consume.consume(expected_type: [:keyword],
                      expected_value: ['resize_window'])
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
      return false if %w[name id].all? { |val| var_names.include?(val) }
      return false if %w[name id].none? { |val| var_names.include?(val) }

      true
    end
  end
end
