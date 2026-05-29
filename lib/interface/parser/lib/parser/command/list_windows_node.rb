# frozen_string_literal: true

# project namespace
module CLIChess
  # process command new_window
  class ListWindowsNode < WindowNode
    def run
      self.cmd_node = new_command_node(tokens.current, :console_command)
      consume.consume(expected_type: [:keyword],
                      expected_value: ['list_windows'])

      cmd_node
    end
  end
end
