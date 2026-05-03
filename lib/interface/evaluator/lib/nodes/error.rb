# frozen_string_literal: true

# project namespace
module CLIChess
  # error message
  class ErrorMsg
    attr_reader :error_msg, :start_pos, :line, :type

    def initialize(**kwargs)
      @type = :error
      @line = kwargs[:parms][:line]
      @start_pos = kwargs[:parms][:start_pos]

      @error_msg = kwargs[:parms][:error_msg]
    end

    def to_s
      error_location = "line: #{line} (#{start_pos})"
      "#{error_msg} #{error_location}"
    end
  end
end
