# frozen_string_literal: true

# project namespace
module CLIChess
  # process command new_window
  class NewWindowNode < WindowNode
    ARGUMENT_NAMES = %w[name type origin cols rows].freeze

    def cont_initialize(parms:)
      @mandatory_args = ARGUMENT_NAMES.map { |item| item }
      @allowed_args = ARGUMENT_NAMES.map { |item| item }
    end

    # > new_window name='WIN0', type='simple', origin='1;1', cols=30, rows=20
    def run
      self.cmd_node = new_command_node(tokens.current, :console_command)
      consume.consume(expected_type: [:keyword], expected_value: ['new_window'])
      add_command_arguments

      return error_node unless valid_command_node?

      cmd_node
    end
  end
end
