# frozen_string_literal: true

# project namespace
module CLIChess
  # evaluator runtime object
  class Value
    attr_reader :value, :line, :start_pos, :type

    def initialize(**kwargs)
      @type = kwargs[:parms][:type]
      @value = kwargs[:parms][:value]
      @line = kwargs[:parms][:line]
      @start_pos = kwargs[:parms][:start_pos]

      cont_initialize(**kwargs)
    end

    def cont_initialize(**kwargs)
      raise NotImplementedError, '#cont_initialize not implemented.'
    end

    def +(other)
      raise NotImplementedError, '#+(other)_initialize not implemented.'
    end

    def -(other)
      raise NotImplementedError, '#-(other)_initialize not implemented.'
    end

    def *(other)
      raise NotImplementedError, '#*(other)_initialize not implemented.'
    end

    def /(other)
      raise NotImplementedError, '#/(other)_initialize not implemented.'
    end

    def %(other)
      raise NotImplementedError, '#%(other)_initialize not implemented.'
    end

    def to_s
      "#{self.class.name}, type: #{type}, value: #{value}"
    end
  end
end
