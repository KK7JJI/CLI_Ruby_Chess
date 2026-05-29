# frozen_string_literal: true

# project namespace
module CLIChess
  # process command new_window
  class RefreshDisplayNode < WindowNode
    def run
      self.cmd_node = new_command_node(tokens.current, :console_command)
      consume.consume(expected_type: [:keyword],
                      expected_value: ['refresh_display'])

      cmd_node
    end
  end
end
