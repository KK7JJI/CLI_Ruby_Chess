# frozen_string_literal: true

# project namespace
module CLIChess
  # evaluator integer object
  class StringValue < Value
    def cont_initialize(_kwargs)
      nil
    end

    def +(other)
      if [Integer, String].include?(other.value.class)
        parms = { type: :string,
                  value: value + other.value.to_s,
                  line: line,
                  start_pos: start_pos }
        return StringValue.new(parms: parms)
      end

      raise TypeError, "cannot add #{value.class} " \
                       "to #{other.value.class}" \
                       ", line: #{line} (#{start_pos})"
    end

    def *(other)
      if other.value.is_a?(Integer)
        parms = { type: :string,
                  value: value * other.value,
                  line: line,
                  start_pos: start_pos }
        return StringValue.new(parms: parms)
      end
      raise TypeError, "cannot multiply #{value.class} " \
                       "by #{other.value.class}" \
                       ", line: #{line} (#{start_pos})"
    end

    def ==(other)
      if other.value.is_a?(String)
        parms = { type: :boolean,
                  value: value == other.value,
                  line: line,
                  start_pos: start_pos }
        return BooleanValue.new(parms: parms)
      end
      parms = { value: false,
                line: line,
                start_pos: start_pos }
      BooleanValue.new(parms: parms)
    end

    def !=(other)
      if other.value.is_a?(String)
        parms = { type: :boolean,
                  value: value != other.value,
                  line: line,
                  start_pos: start_pos }
        return BooleanValue.new(parms: parms)
      end
      parms = { type: :boolean,
                value: true,
                line: line,
                start_pos: start_pos }
      BooleanValue.new(parms: parms)
    end

    def <=(other)
      if other.value.is_a?(String)
        parms = { type: :boolean,
                  value: value <= other.value,
                  line: line,
                  start_pos: start_pos }
        return BooleanValue.new(parms: parms)
      end
      raise TypeError, "comparison of #{value.class} " \
                       "with #{other.value.class} has failed" /
                       ", line: #{line} (#{start_pos})"
    end

    def >=(other)
      if other.value.is_a?(String)
        parms = { type: :boolean,
                  value: value >= other.value,
                  line: line,
                  start_pos: start_pos }
        return BooleanValue.new(parms: parms)
      end
      raise TypeError, "comparison of #{value.class} " \
                       "with #{other.value.class} has failed" /
                       ", line: #{line} (#{start_pos})"
    end

    def <(other)
      if other.value.is_a?(String)
        parms = { type: :boolean,
                  value: value < other.value,
                  line: line,
                  start_pos: start_pos }
        return BooleanValue.new(parms: parms)
      end
      raise TypeError, "comparison of #{value.class} " \
                       "with #{other.value.class} has failed" /
                       ", line: #{line} (#{start_pos})"
    end

    def >(other)
      if other.value.is_a?(String)
        parms = { type: :boolean,
                  value: value > other.value,
                  line: line,
                  start_pos: start_pos }
        return BooleanValue.new(parms: parms)
      end
      raise TypeError, "comparison of #{value.class} " \
                       "with #{other.value.class} has failed" /
                       ", line: #{line} (#{start_pos})"
    end

    def !
      parms = { type: :boolean,
                value: false,
                line: line,
                start_pos: start_pos }
      BooleanValue.new(parms: parms)
    end
  end
end
