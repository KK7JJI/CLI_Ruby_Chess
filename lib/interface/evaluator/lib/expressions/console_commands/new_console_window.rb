# frozen_string_literal: true

# project namespace
module CLIChess
  # evaluator for keyword based command execution
  class NewConsoleWindow
    include ErrorMessage

    attr_reader :display, :evaluator, :node

    def self.call(evaluator: nil, display: nil, node: nil)
      new(evaluator, display, node).call
    end

    def initialize(evaluator, display, node)
      @evaluator = evaluator
      @display = display
      @node = node
    end

    def call
      exec_new_window
    end

    def exec_new_window
      args = command_args

      error_msg = validate_args(args)
      return error_msg if error_msg

      display_commands

      msg = "#{node.value} executed."
      return_message(node, msg: msg)
    end

    def display_commands
      display.new_window(
        name: evaluator.variables['name'][:value],
        new_origin: win_origin(evaluator.variables['origin'][:value]),
        rows: evaluator.variables['rows'][:value],
        cols: evaluator.variables['cols'][:value],
        option: evaluator.variables['type'][:value].to_sym
      )
      display.refresh_display
    end

    def command_args
      node.args.map do |arg|
        evaluator.walk(arg)
      end
    end

    def validate_args(args)
      args.each { |arg| return arg if arg.type == :error }

      unless new_window_valid_args?
        msg = 'One or more invalid arguments.'
        return evaluator_error(node, msg: msg)
      end

      nil
    end

    def new_window_valid_args?
      # all arguments are evaluator.variables
      win_types = %w[simple scrolling interactive]
      unless /\d+[;,|]\d+/.match?(evaluator.variables['origin'][:value])
        return false
      end
      return false unless /^\w+$/.match?(evaluator.variables['name'][:value])
      return false unless evaluator.variables['rows'][:value].is_a?(Integer)
      return false unless evaluator.variables['cols'][:value].is_a?(Integer)
      unless win_types.include?(evaluator.variables['type'][:value])
        return false
      end

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
