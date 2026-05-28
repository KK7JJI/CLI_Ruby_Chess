# frozen_string_literal: true

# project namespace
module CLIChess
  # evaluator for keyword based command execution
  class ActivateWindow
    include ErrorMessage
    include OutputMSG

    ARGUMENT_NAMES = %w[name id].freeze

    attr_reader :display, :evaluator, :node
    attr_accessor :args

    def self.call(evaluator: nil, display: nil, node: nil)
      new(evaluator, display, node).call
    end

    def initialize(evaluator, display, node)
      @evaluator = evaluator
      @display = display
      @node = node
      @args = []
    end

    def call
      initialize_arguments
      exec_activate_window
    end

    def initialize_arguments
      ARGUMENT_NAMES.each do |name|
        evaluator.variables.delete(name)
      end
    end

    def exec_activate_window
      self.args = node.args.map do |arg|
        evaluator.walk(arg)
      end

      args.each do |arg|
        return arg if arg.type == :error
      end

      unless valid_args?
        msg = 'One or more invalid arguments.'
        return evaluator_error(node, msg: msg)
      end

      display.activate_window(args[0].value)

      display.refresh_display

      msg = "#{node.value} executed."
      return_message(node, msg: msg)
    end

    def valid_args?
      # arguments can be:
      # variable name
      # variable id
      # integer
      # string
      return false if args.empty?

      true
    end

    def return_message(node, msg: nil)
      ReturnMessage.new(parms: {
                          type: :message,
                          line: node.line,
                          start_pos: node.start_pos,
                          msg: msg
                        })
    end
  end
end
