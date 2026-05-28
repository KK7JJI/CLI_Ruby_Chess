# frozen_string_literal: true

# project namespace
module CLIChess
  # process command new_window
  class MoveWindowNode
    include NewErrorNode
    include NewCommandNode
    include OutputMSG

    attr_accessor :return_node, :tokens, :consume, :parser,
                  :cmd_node, :var_names

    ARGUMENT_NAMES = %w[name id loc].freeze
    PUNCTUATION = [',', ':', ';', '--', '-'].freeze

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
      command_move_window
    end

    def command_move_window
      # sample> move_window name='WIN1', loc='2;3'
      # sample> move_window id=1, loc='2;3'

      # 3) define expected tokens which are expected for this command keyword.
      self.cmd_node = new_command_node(tokens.current, :console_command)
      consume.consume(expected_type: [:keyword],
                      expected_value: ['move_window'])

      add_command_arguments

      # 4) return either an error node or a command node.
      return error_node unless valid_command_node?

      cmd_node
    end

    def add_command_arguments
      # var_names -> user supplied arguments, id, loc
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
      cmd_node.args << parser.parse_new_assignment(var_names: var_names)
      var_names.delete(var_name)
    end

    def error_node
      return unless var_names.include?('loc')

      tokens.insert_token(
        tokens.error_token(error_msg: error_message)
      )
      new_error_node
    end

    def valid_command_node?
      return false if tokens.current && tokens.current.type == :error
      return false if %w[name id].all? { |val| var_names.include?(val) }
      return false if %w[name id].none? { |val| var_names.include?(val) }

      !var_names.include?('loc')
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
