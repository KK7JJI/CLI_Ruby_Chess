# frozen_string_literal: true

# namespace for the project
module CLIChess
  # new window parameters
  class WindowMetrics
    attr_reader :reference, :new_origin, :rows, :cols

    def initialize(rows:, cols:, reference: [1, 1],
                   new_origin: [0, 0])
      @reference = reference
      @new_origin = new_origin
      @rows = rows
      @cols = cols
    end
  end
end
