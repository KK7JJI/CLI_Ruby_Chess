# frozen_string_literal: true

# project namespace
module CLIChess
  # error message
  class ReturnMessage
    attr_reader :msg, :start_pos, :line, :type

    def initialize(**kwargs)
      @type = :message
      @line = kwargs[:parms][:line]
      @start_pos = kwargs[:parms][:start_pos]

      @msg = kwargs[:parms][:msg]
    end

    def to_s
      msg
    end
  end
end
