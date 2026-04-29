# frozen_string_literal: true

# namespace for the project
module CLIChess
  # evaluate parser nodes
  class Stack
    attr_accessor :ptr, :contents, :size

    def initialize(size = 100)
      @contents = Array.new(size)
      @size = size
      @ptr = -1
    end

    def pop
      raise 'Attempt to pop item from empty stack.' if empty?

      self.ptr -= 1
      contents[ptr + 1]
    end

    def push(value)
      self.ptr += 1
      raise 'Stack overflow.' if overflow?

      contents[ptr] = value
    end

    def empty?
      return true if ptr.negative?

      false
    end

    def overflow?
      return true if ptr >= size

      false
    end

    def to_s
      return nil if ptr.negative?

      msg = []
      (ptr + 1).times do |idx|
        msg << contents[idx].to_s
      end
      msg.reverse.join("\n")
    end
  end
end
