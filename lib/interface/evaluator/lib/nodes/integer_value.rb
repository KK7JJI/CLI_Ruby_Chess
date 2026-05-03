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
      return other if other.type == :error

      if other.type == :integer
        parms = { type: :integer,
                  value: value + other.value,
                  line: line,
                  start_pos: start_pos }
        return IntegerValue.new(parms: parms)
      end
      if other.type == :string
        parms = { type: :string,
                  value: value.to_s + other.value,
                  line: line,
                  start_pos: start_pos }
        return StringValue.new(parms: parms)
      end

      msg = "cannot add #{type} to #{other.type}"
      error_message(error_msg: msg, line: other.line,
                    start_pos: other.start_pos)
    end

    def -(other)
      return other if other.type == :error

      if other.type == :integer
        parms = { type: :integer,
                  value: value - other.value,
                  line: line,
                  start_pos: start_pos }
        return IntegerValue.new(parms: parms)
      end

      msg = "cannot subtract #{type} " \
            "from #{other.type}"
      error_message(error_msg: msg, line: other.line,
                    start_pos: other.start_pos)
    end

    def *(other)
      return other if other.type == :error

      if other.type == :integer
        parms = { type: :integer,
                  value: value * other.value,
                  line: line,
                  start_pos: start_pos }
        return IntegerValue.new(parms: parms)
      end

      msg = "cannot multiply #{type} " \
            "by #{other.type}"
      error_message(error_msg: msg, line: other.line,
                    start_pos: other.start_pos)
    end

    def /(other)
      return other if other.type == :error

      if other.value.respond_to?(:zero?) && other.value.zero?
        msg = 'Division by zero error'
        return error_message(error_msg: msg, line: other.line,
                             start_pos: other.start_pos)
      end

      if other.type == :integer
        parms = { type: :integer,
                  value: value / other.value,
                  line: line,
                  start_pos: start_pos }
        return IntegerValue.new(parms: parms)
      end

      msg = "cannot divide #{type} " \
            "by #{other.type}"
      error_message(error_msg: msg, line: other.line,
                    start_pos: other.start_pos)
    end

    def %(other)
      return other if other.type == :error

      if other.value.respond_to?(:zero?) && other.value.zero?
        msg = 'Division by zero error'
        return error_message(error_msg: msg, line: other.line,
                             start_pos: other.start_pos)
      end

      if other.type == :integer
        parms = { type: :integer,
                  value: value % other.value,
                  line: line,
                  start_pos: start_pos }
        return IntegerValue.new(parms: parms)
      end

      msg = "cannot divide #{type} " \
            "by #{other.type}"
      error_message(error_msg: msg, line: other.line,
                    start_pos: other.start_pos)
    end

    def -@
      parms = { type: :integer,
                value: -1 * value,
                line: line,
                start_pos: start_pos }
      IntegerValue.new(parms: parms)
    end

    def +@
      parms = { type: :integer,
                value: value,
                line: line,
                start_pos: start_pos }
      IntegerValue.new(parms: parms)
    end

    def ==(other)
      return other if other.type == :error

      if other.type == :integer
        parms = { type: :boolean,
                  value: value == other.value,
                  line: line,
                  start_pos: start_pos }
        return BooleanValue.new(parms: parms)
      end
      parms = { type: :boolean,
                value: false,
                line: line,
                start_pos: start_pos }
      BooleanValue.new(parms: parms)
    end

    def !=(other)
      return other if other.type == :error

      if other.type == :integer
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

      if other.type == :integer
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

      if other.type == :integer
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

      if other.type == :integer
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

      if other.type == :integer
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
