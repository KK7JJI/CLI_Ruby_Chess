# frozen_string_literal: true

# project namespace
module CLIChess
  # evaluator integer object
  class StringValue < Value
    def cont_initialize(_kwargs)
      nil
    end

    def +(other)
      return other if other.type == :error

      if %i[integer string].include?(other.type)
        parms = { type: :string,
                  value: value + other.value.to_s,
                  line: line,
                  start_pos: start_pos }
        return StringValue.new(parms: parms)
      end

      msg = "cannot add #{type} " \
            "to #{other.type}"
      error_message(error_msg: msg, line: other.line,
                    start_pos: other.start_pos)
    end

    def *(other)
      return other if other.type == :error

      if other.type == :integer
        parms = { type: :string,
                  value: value * other.value,
                  line: line,
                  start_pos: start_pos }
        return StringValue.new(parms: parms)
      end
      msg = "cannot multiply #{type} " \
            "by #{other.type}"
      error_message(error_msg: msg, line: other.line,
                    start_pos: other.start_pos)
    end

    def ==(other)
      return other if other.type == :error

      if other.type == :string
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
      return other if other.type == :error

      if other.type == :string
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
      return other if other.type == :error

      if other.type == :string
        parms = { type: :boolean,
                  value: value <= other.value,
                  line: line,
                  start_pos: start_pos }
        return BooleanValue.new(parms: parms)
      end
      msg = "comparison of #{type} " \
            "with #{other.type} has failed"
      error_message(error_msg: msg, line: other.line,
                    start_pos: other.start_pos)
    end

    def >=(other)
      return other if other.type == :error

      if other.type == :string
        parms = { type: :boolean,
                  value: value >= other.value,
                  line: line,
                  start_pos: start_pos }
        return BooleanValue.new(parms: parms)
      end
      msg = "comparison of #{type} " \
            "with #{other.type} has failed"
      error_message(error_msg: msg, line: other.line,
                    start_pos: other.start_pos)
    end

    def <(other)
      return other if other.type == :error

      if other.type == :string
        parms = { type: :boolean,
                  value: value < other.value,
                  line: line,
                  start_pos: start_pos }
        return BooleanValue.new(parms: parms)
      end
      msg = "comparison of #{type} " \
            "with #{other.type} has failed"
      error_message(error_msg: msg, line: other.line,
                    start_pos: other.start_pos)
    end

    def >(other)
      return other if other.type == :error

      if other.type == :string
        parms = { type: :boolean,
                  value: value > other.value,
                  line: line,
                  start_pos: start_pos }
        return BooleanValue.new(parms: parms)
      end
      msg = "comparison of #{type} " \
            "with #{other.type} has failed"
      error_message(error_msg: msg, line: other.line,
                    start_pos: other.start_pos)
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
