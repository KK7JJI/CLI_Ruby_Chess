# frozen_string_literal: true

# project namespace
module CLIChess
  # process tokens to run a command
  class Command
    include NewErrorNode
    include OutputMSG

    attr_reader :parms, :tokens

    # 1) lookup a command classname via keyword hash.
    COMMANDS = {
      'new_window' => NewWindowNode,
      'list_windows' => ListWindowsNode,
      'close_window' => CloseWindowNode,
      'activate_window' => ActivateWindowNode
    }

    def initialize(parms:)
      @parms = parms
      @parser = parms[:parser]
      @consume = parms[:consume]
      @tokens = parms[:tokens]
      @assignment = parms[:assignment]
    end

    def parse_command
      return nil unless tokens.current&.type == :keyword
      return nil unless COMMANDS.include?(tokens.current&.name)

      # 2) call the command class's call class method.  This
      #    will generate command nodes.
      COMMANDS[tokens.current&.name].call(parms: parms)
    end
  end
end
