# frozen_string_literal: true

# project namespace
module CLIChess
  # process command new_window
  class ListWindowsNode
    include NewErrorNode
    include NewCommandNode
    include OutputMSG

    attr_accessor :return_node, :tokens, :consume, :cmd_node

    def self.call(parms:)
      # 1) for the command, start with a class method
      new(parms: parms).call
    end

    def initialize(parms:)
      @consume = parms[:consume]
      @tokens = parms[:tokens]
      @cmd_node = nil
    end

    def call
      # 2) call the object method
      command_list_windows
    end

    def command_list_windows
      # sample> list_windows

      # 3) define expected tokens which are expected for this command keyword.
      self.cmd_node = new_command_node(tokens.current, :console_command)
      consume.consume(expected_type: [:keyword],
                      expected_value: ['list_windows'])

      # 4) return either an error node or a command node.
      # return error_node

      cmd_node
    end
  end
end
