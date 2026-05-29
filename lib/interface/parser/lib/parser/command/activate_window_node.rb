# frozen_string_literal: true

# project namespace
module CLIChess
  # process command new_window
  class ActivateWindowNode < WindowNode
    ARGUMENT_NAMES = %w[name id].freeze

    def cont_initialize(parms:)
      @required_args = true
      @mandatory_args = []
      @allowed_args = ARGUMENT_NAMES.map { |name| name }
    end

    def run
      # sample> activate_window name='WIN1'
      # sample> activate_window id=1

      self.cmd_node = new_command_node(tokens.current, :console_command)
      consume.consume(expected_type: [:keyword],
                      expected_value: ['activate_window'])
      add_command_arguments # expect 0 - 1 arguments

      return error_node unless valid_command_node?

      cmd_node
    end

    def valid_command_node?
      var_names = cmd_node.args.map { |arg| arg.value }
      return false if tokens.current && tokens.current.type == :error
      return false if allowed_args.all? { |name| var_names.include?(name) }
      return false if allowed_args.none? { |name| var_names.include?(name) }
      return !var_names.empty? if required_args

      true
    end
  end
end
