# frozen_string_literal: true

# project namespace
module CLIChess
  # generic parser node
  class Node
    include Serialize

    attr_accessor :line, :start_pos, :data, :type

    def initialize(**kwargs)
      @type = nil
      @line = kwargs[:parms][:line]
      @start_pos = kwargs[:parms][:start_pos]

      cont_initialize(**kwargs)
    end

    def cont_initialize(**kwargs)
      raise NotImplementedError, '#cont_initialize not implemented.'
    end

    def pretty_print(indent = 0)
      puts "#{indent_str(indent)}#{self.class.name}"
    end

    def indent_str(level)
      ' ' * level
    end

    def to_s
      raise NotImplementedError, '#to_s not implemented.'
    end

    def self.json_create(hash)
      obj = allocate
      obj.json_create(allocate, hash)
    end
  end
end
