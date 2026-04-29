# frozen_string_literal: true

# project namespace
module CLIChess
  # evaluator integer object
  class BooleanValue < Value
    def cont_initialize(_kwargs)
      nil
    end

    def ==(other)
      if other.is_a?(BooleanValue)
        parms = { value: value == other.value, line: line,
                  start_pos: start_pos }
        return BooleanValue.new(parms: parms)
      end
      parms = { value: false, line: line, start_pos: start_pos }
      BooleanValue.new(parms: parms)
    end

    def !=(other)
      if other.is_a?(BooleanValue)
        parms = { value: value != other.value, line: line,
                  start_pos: start_pos }
        return BooleanValue.new(parms: parms)
      end
      parms = { value: true, line: line, start_pos: start_pos }
      BooleanValue.new(parms: parms)
    end

    def !
      result = true if value.to_s == 'false'
      result = false if value.to_s == 'true'
      parms = { value: result, line: line, start_pos: start_pos }
      BooleanValue.new(parms: parms)
    end
  end
end
