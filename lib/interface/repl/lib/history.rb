# frozen_string_literal: true

module CLIChess
  # pointer based stack
  class History
    attr_accessor :pos, :start, :size, :contents

    def initialize(size: 100)
      @size = size
      @contents = Array.new(size)
      @pos = 0
      @start = 0
    end

    def push(value)
      contents[pos] = value
      self.pos += 1
      self.pos = pos % size
      return unless self.pos == start

      self.start += 1 if self.pos == start
      self.start %= size
    end

    def last(index = 0)
      return nil if empty?
      return contents[pos] if index.zero?

      index %= size
      index = pos - index - 1
      index += size if index.negative?
      contents[index]
    end

    def to_s
      msg = []
      10.times do |idx|
        index = pos - idx - 1
        index += size if index.negative?
        msg << "#{idx} #{contents[index]}"
      end
      msg.reverse.join("\n")
    end

    def empty?
      contents.all?(nil)
    end
  end
end
