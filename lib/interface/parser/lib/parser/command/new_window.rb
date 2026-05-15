# frozen_string_literal: true

# project namespace
module CLIChess
  # process command new_window
  class NewWindow
    include NewErrorNode
    include NewCommandNode
    include OutputMSG

    attr_accessor :return_node, :tokens, :consume, :assignment, :var_names,
                  :cmd_node

    ARGUMENT_NAMES = %w[type origin columns rows].freeze
    PUNCTUATION = [',', ':', ';', '--', '-'].freeze

    def self.call(parms:)
      # 1) for the command, start with a class method
      new(parms: parms).call
    end

    def initialize(parms:)
      output_msg(msg: __method__)

      @consume = parms[:consume]
      @assignment = parms[:assignment]
      @tokens = parms[:tokens]
      @var_names = ARGUMENT_NAMES.map { |item| item }
      @cmd_node = nil
    end

    def call
      # 2) call the object method
      command_new_window
    end

    def command_new_window
      # sample> new_window type='simple', origin='1;1', columns=30, rows=20

      # 3) define expected tokens which are expected for this command keyword.

      token = tokens.current
      consume.consume(expected_type: [:keyword], expected_value: ['new_window'])
      self.cmd_node = new_command_node(token, :console_command)
      add_command_arguments

      # 4) return either an error node or a command node.
      return error_node unless valid_command_node?

      cmd_node
    end

    def add_command_arguments
      # var_names -> user supplied arguments, type, origin, columns, rows
      # each occurs only one time.

      cmd_argument
      while argument_delimiter?
        # consume will generate an error token if something unexpected is seen.
        consume.consume(expected_type: [:punctuation],
                        expected_value: PUNCTUATION)
        cmd_argument
      end
    end

    def cmd_argument
      var_name = tokens.current&.name if tokens.current&.type == :variable
      cmd_node.args << assignment.parse_assignment(var_names: var_names)
      var_names.delete(var_name)
    end

    def valid_command_node?
      return false if tokens.current && tokens.current.type == :error

      var_names.empty?
    end

    def error_node
      return if var_names.empty?

      tokens.insert_token(
        tokens.error_token(error_msg: error_message)
      )
      new_error_node
    end

    def error_message
      self.var_names = var_names.map { |name| "\"#{name}\"" }
      "\"#{cmd_node.value}\" missing arguments #{var_names.join(', ')}"
    end

    def argument_delimiter?
      return false if tokens.current.nil?
      return false unless tokens.current.type == :punctuation
      return false unless PUNCTUATION.include?(tokens.current.name)

      true
    end
  end
end
