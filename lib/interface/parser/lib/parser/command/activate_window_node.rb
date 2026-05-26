# frozen_string_literal: true

# project namespace
module CLIChess
  # process command new_window
  class ActivateWindowNode
    include NewErrorNode
    include NewCommandNode
    include OutputMSG

    attr_accessor :return_node, :tokens, :consume, :parser,
                  :cmd_node, :var_names

    ARGUMENT_NAMES = %w[name id].freeze

    def self.call(parms:)
      # 1) for the command, start with a class method
      new(parms: parms).call
    end

    def initialize(parms:)
      @consume = parms[:consume]
      @parser = parms[:parser]
      @tokens = parms[:tokens]
      @var_names = ARGUMENT_NAMES.map { |item| item }
      @cmd_node = nil
    end

    def call
      # 2) call the object method
      command_activate_window
    end

    def command_activate_window
      # sample> activate_window 'WIN1'
      # sample> activate_window name='WIN1'
      # sample> activate_window id=1

      # 3) define expected tokens which are expected for this command keyword.
      self.cmd_node = new_command_node(tokens.current, :console_command)
      consume.consume(expected_type: [:keyword],
                      expected_value: ['activate_window'])
      add_command_arguments # expect 0 - 1 arguments

      # 4) return either an error node or a command node.
      return error_node unless valid_command_node?

      cmd_node
    end

    def add_command_arguments
      cmd_argument
    end

    def cmd_argument
      return if tokens.current.nil? # no argument provided

      cmd_node.args << if tokens.current.type == :variable
                         parser.parse_new_assignment(var_names: var_names)
                       else
                         parser.parse_new_expression
                       end
    end

    def error_node
      new_error_node
    end

    def valid_command_node?
      return false if tokens.current && tokens.current.type == :error

      true
    end
  end
end
