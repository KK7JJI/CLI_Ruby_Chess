# frozen_string_literal: true

# project namespace
module CLIChess
  # evaluator for keyword based command execution
  class MoveWindow
    include ErrorMessage
    include OutputMSG

    attr_reader :display, :evaluator, :node
    attr_accessor :args

    ARGUMENT_NAMES = %w[name id loc].freeze

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
      exec_move_window
    end

    def initialize_arguments
      ARGUMENT_NAMES.each do |name|
        evaluator.variables.delete(name)
      end
    end

    def exec_move_window
      self.args = command_args

      error_msg = validate_args
      return error_msg if error_msg

      display_commands

      msg = "#{node.value} executed."
      return_message(node, msg: msg)
    end

    def display_commands
      # need to add arguments
      location = win_origin(evaluator.variables['loc'][:value])
      value = evaluator.variables['name'][:value] if arg?('name')
      value = evaluator.variables['id'][:value] if arg?('id')
      display.move_window(value, location)
      display.refresh_display
    end

    def command_args
      node.args.map do |arg|
        evaluator.walk(arg)
      end
    end

    def validate_args
      args.each { |arg| return arg if arg.type == :error }

      unless valid_args?
        msg = 'One or more invalid arguments.'
        return evaluator_error(node, msg: msg)
      end

      nil
    end

    def valid_args?
      return false unless %w[name id].any? do |key|
        evaluator.variables.key?(key)
      end
      return false unless evaluator.variables.key?('loc')
      return false unless valid_name?
      return false unless valid_id?

      unless /^\d+[;:,|]\d+$/.match?(evaluator.variables['loc'][:value])
        return false
      end

      true
    end

    def arg?(value)
      evaluator.variables.key?(value)
    end

    def valid_name?
      return true unless arg?('name')
      return false unless /^\w+$/.match?(evaluator.variables['name'][:value])

      true
    end

    def valid_id?
      return true unless arg?('id')
      return false unless evaluator.variables['id'][:value].is_a?(Integer)

      true
    end

    def win_origin(value)
      # expect "1;1"
      [':', ',', '|'].each do |punc|
        value = value.sub(punc, ';')
      end
      value.split(';').map { |coord| coord.to_i }
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
