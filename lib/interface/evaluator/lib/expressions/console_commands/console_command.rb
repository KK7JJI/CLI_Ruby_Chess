# frozen_string_literal: true

module CLIChess
  # console command base class
  class ConsoleCommand
    include ErrorMessage
    include ConsoleMixins
    include OutputMSG

    attr_reader :display, :evaluator, :node
    attr_accessor :args, :argument_names

    def self.call(evaluator: nil, display: nil, node: nil)
      new(evaluator, display, node).call
    end

    def initialize(evaluator, display, node)
      @evaluator = evaluator
      @display = display
      @node = node
      @args = []

      cont_initialize
    end

    def call
      initialize_arguments
      exec_command
    end

    def cont_initialize
      @argument_names = []
    end

    def initialize_arguments
      argument_names.each do |name|
        evaluator.variables.delete(name)
      end
    end

    def exec_command
      output_msg(msg: __method__)
      self.args = command_args

      error_msg = validate_args
      return error_msg if error_msg

      display_commands

      msg = "#{node.value} executed."
      return_message(node, msg: msg)
    end

    def display_commands
      raise NotImplementedError
    end

    def command_args
      node.args.map do |arg|
        evaluator.walk(arg)
      end
    end

    def validate_args
      output_msg(msg: evaluator.variables.inspect)
      args.each { |arg| return arg if arg.type == :error }

      unless valid_args?
        msg = 'One or more invalid arguments.'
        return evaluator_error(node, msg: msg)
      end

      nil
    end

    def valid_args?
      raise NotImplementedError
    end
  end
end
