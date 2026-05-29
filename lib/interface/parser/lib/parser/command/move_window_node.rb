# frozen_string_literal: true

# project namespace
module CLIChess
  # process command new_window
  class MoveWindowNode < WindowNode
    MANDATORY_ARGS = %w[loc].freeze
    ARGUMENT_NAMES = %w[name id loc].freeze

    def cont_initialize(parms:)
      @required_args = true
      @mandatory_args = MANDATORY_ARGS.map { |item| item }
      @allowed_args = ARGUMENT_NAMES.map { |item| item }
    end

    def run
      self.cmd_node = new_command_node(tokens.current, :console_command)
      consume.consume(expected_type: [:keyword],
                      expected_value: ['move_window'])
      add_command_arguments

      return error_node unless valid_command_node?

      cmd_node
    end

    def valid_command_node?
      var_names = cmd_node.args.map { |arg| arg.value }
      return false if tokens.current && tokens.current.type == :error
      return false if %w[name id].all? { |val| var_names.include?(val) }
      return false if %w[name id].none? { |val| var_names.include?(val) }
      return false unless mandatory_args.empty?
      return !var_names.empty? if required_args

      true
    end
  end
end
