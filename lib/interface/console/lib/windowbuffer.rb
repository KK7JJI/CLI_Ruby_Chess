# frozen_string_literal: true

# namespace for the project
module CLIChess
  # store lines for display in a window
  class WindowBuffer
    attr_accessor :current, :contents, :rows

    def initialize(rows: nil)
      @rows = rows
      @current = -1
      @contents = Array.new(rows - 2) { '' }
    end

    def refresh
      return [] if empty?

      result = []
      (rows - 2).times do |idx|
        ptr = current
        ptr -= idx
        ptr += (rows - 2) if ptr.negative?
        result << contents[ptr]
      end
      result
    end

    def append_last(value, sep: ' ')
      # i.e. add something to the prompt
      contents[current] += (sep + value)
    end

    def push(value)
      self.current += 1
      self.current %= (rows - 2)
      contents[current] = value
    end

    def empty?
      return true if contents.all?('')

      false
    end
  end
end
