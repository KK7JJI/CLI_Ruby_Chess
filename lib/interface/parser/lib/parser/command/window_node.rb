# frozen_string_literal: true

module CLIChess
  # base class for console window command nodes.
  class WindowNode
    include NewErrorNode
    include NewCommandNode

    attr_accessor :return_node, :tokens, :parser, :consume, :mandatory_args,
                  :allowed_args, :cmd_node

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

    def cont_initialize(_parms:)
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
      cmd_node.args << parser.parse_new_assignment(var_names: allowed_args)
      mandatory_args.delete(arg_name)
    end

    def valid_command_node?
      return false if tokens.current && tokens.current.type == :error

      mandatory_args.empty?
    end

    def error_node
      return if mandatory_args.empty?

      # insert an error token and then build an error node.
      #
      # These steps are only necessary if we haven't seen all mandatory
      # arguments. If parsing an argument produced an error it
      # an error token exists and will be handled in the evaluator
      # process.
      #
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
