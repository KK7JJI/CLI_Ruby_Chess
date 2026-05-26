# frozen_string_literal: true

# project namespace
module CLIChess
  # evaluator for keyword based command execution
  class ListWindows
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
      exec_list_windows
    end

    def exec_list_windows
      display.list_windows
      display.refresh_display

      msg = "#{node.value} executed."
      return_message(node, msg: msg)
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
