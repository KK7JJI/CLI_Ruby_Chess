# frozen_string_literal: true

# project namespace
module CLIChess
  # evaluator integer object
  class IntegerValue < Value
    def cont_initialize(**kwargs)
      raise "#{kwargs[:parms][:value]} is not type Integer, pos #{start_pos}" \
        unless kwargs[:parms][:value].to_s == kwargs[:parms][:value].to_i.to_s

      @value = kwargs[:parms][:value].to_i
    end

    def +(other)
      if other.value.is_a?(Integer)
        parms = { value: value + other.value, line: line, start_pos: start_pos }
        return IntegerValue.new(parms: parms)
      end
      if other.value.is_a?(String)
        return StringValue.new(value: value.to_s + other.value, line: line,
                               start_pos: start_pos)
      end

      raise TypeError, "cannot add #{value.class} " \
                       "to #{other.value.class}, pos: #{start_pos}"
    end

    def -(other)
      if other.value.is_a?(Integer)
        parms = { value: value - other.value, line: line, start_pos: start_pos }
        return IntegerValue.new(parms: parms)
      end
      raise TypeError, "cannot subtract #{value.class} " \
                       "from #{other.value.class}, pos: #{start_pos}"
    end

    def *(other)
      if other.value.is_a?(Integer)
        parms = { value: value * other.value, line: line, start_pos: start_pos }
        return IntegerValue.new(parms: parms)
      end
      raise TypeError, "cannot multiply #{value.class} " \
                       "by #{other.value.class}, pos: #{start_pos}"
    end

    def /(other)
      raise "Divide by zero error, pos: #{start_pos}" if other.value.zero?

      if other.value.is_a?(Integer)
        parms = { value: value / other.value, line: line, start_pos: start_pos }
        return IntegerValue.new(parms: parms)
      end

      raise TypeError, "cannot divide #{value.class} " \
                       "by #{other.value.class}, pos: #{start_pos}"
    end

    def %(other)
      raise "Divide by zero error, pos: #{start_pos}" if other.value.zero?

      if other.value.is_a?(Integer)
        parms = { value: value % other.value, line: line, start_pos: start_pos }
        return IntegerValue.new(parms: parms)
      end

      raise TypeError, "cannot divide #{value.class} " \
                       "by #{other.value.class}, pos: #{start_pos}"
    end

    def -@
      parms = { value: -1 * value, line: line, start_pos: start_pos }
      IntegerValue.new(parms: parms)
    end

    def +@
      parms = { value: value, line: line, start_pos: start_pos }
      IntegerValue.new(parms: parms)
    end

    def ==(other)
      if other.value.is_a?(Integer)
        parms = { value: value == other.value, line: line,
                  start_pos: start_pos }
        return BooleanValue.new(parms: parms)
      end
      parms = { value: false, line: line, start_pos: start_pos }
      BooleanValue.new(parms: parms)
    end

    def !=(other)
      if other.value.is_a?(Integer)
        parms = { value: value != other.value, line: line,
                  start_pos: start_pos }
        return BooleanValue.new(parms: parms)
      end
      parms = { value: true, line: line, start_pos: start_pos }
      BooleanValue.new(parms: parms)
    end

    def <=(other)
      if other.value.is_a?(Integer)
        parms = { value: value <= other.value, line: line,
                  start_pos: start_pos }
        return BooleanValue.new(parms: parms)
      end
      raise TypeError, "comparison of #{value.class} " \
                       "with #{other.value.class} has failed - pos: #{start_pos}}"
    end

    def >=(other)
      if other.value.is_a?(Integer)
        parms = { value: value >= other.value, line: line,
                  start_pos: start_pos }
        return BooleanValue.new(parms: parms)
      end
      raise TypeError, "comparison of #{value.class} " \
                       "with #{other.value.class} has failed - pos: #{start_pos}}"
    end

    def <(other)
      if other.value.is_a?(Integer)
        parms = { value: value < other.value, line: line, start_pos: start_pos }
        return BooleanValue.new(parms: parms)
      end
      raise TypeError, "comparison of #{value.class} " \
                       "with #{other.value.class} has failed - pos: #{start_pos}}"
    end

    def >(other)
      if other.value.is_a?(Integer)
        parms = { value: value > other.value, line: line, start_pos: start_pos }
        return BooleanValue.new(parms: parms)
      end
      raise TypeError, "comparison of #{value.class} " \
                       "with #{other.value.class} has failed - pos: #{start_pos}}"
    end

    def !
      parms = { value: false, line: line, start_pos: start_pos }
      BooleanValue.new(parms: parms)
    end
  end
end
