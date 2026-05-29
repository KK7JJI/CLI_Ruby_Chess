# frozen_string_literal: true

module CLIChess
  # base class for console window command nodes.
  class WindowNode
    include NewErrorNode
    include NewCommandNode
    include OutputMSG

    attr_accessor :return_node, :tokens, :parser, :consume, :mandatory_args,
                  :allowed_args, :cmd_node, :required_args

    PUNCTUATION = [',', ':', ';', '--', '-'].freeze

    def self.call(parms:)
      # 1) for the command, start with a class method
      new(parms: parms).call
    end

    def initialize(parms:)
      @parser = parms[:parser]
      @consume = parms[:consume]
      @tokens = parms[:tokens]
      @cmd_node = nil

      cont_initialize(parms: parms)
    end

    def call
      run
    end

    def cont_initialize(parms:)
      @required_args = false
      @mandatory_args = []
      @allowed_args = []
    end

    def run
      raise NotImplementedError
    end

    def add_command_arguments
      cmd_argument
      while argument_delimiter?
        # consume will generate an error token if something unexpected is seen.
        consume.consume(expected_type: [:punctuation],
                        expected_value: PUNCTUATION)
        cmd_argument
      end
    end

    def cmd_argument
      arg_name = tokens.current&.name if tokens.current&.type == :variable
      arg = parser.parse_new_assignment(var_names: allowed_args)
      cmd_node.args << arg unless arg.nil?
      mandatory_args.delete(arg_name)
    end

    def valid_command_node?
      var_names = cmd_node.args.map { |arg| arg.value }
      return false if tokens.current && tokens.current.type == :error
      return false unless mandatory_args.empty?
      return !var_names.empty? if required_args

      true
    end

    def error_node
      tokens.insert_token(
        tokens.error_token(error_msg: error_message)
      )
      new_error_node
    end

    def error_message
      "\"#{cmd_node.value}\" missing arguments #{mandatory_args.join(', ')}"
    end

    def argument_delimiter?
      return false if tokens.current.nil?
      return false unless tokens.current.type == :punctuation
      return false unless PUNCTUATION.include?(tokens.current.name)

      true
    end
  end
end
