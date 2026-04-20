# frozen_string_literal: true

# namespace for the project
module CLIChess
  # window manager
  class Display
    attr_accessor :main_window, :windows, :rows, :cols

    def initialize
      @rows, @cols = IO.console.winsize
      @main_window = SimpleWindow.new(cols: cols, rows: (rows - 2))
      @windows = []
      @windows << @main_window
      @active_window = @windows[-1]
    end

    def refresh_display
      windows.each(&:refresh)
    end

    def active_window
      windows[-1]
    end

    def refresh_active
      windows[-1].refresh
    end

    def activate_window(value)
      return if value.nil?

      window = select_window(value)
      return if window.nil?

      windows.delete(window)
      windows.push(window)
    end

    def delete_window(value)
      return nil if value.nil?
      return nil if value.is_a?(Integer) && value.zero?
      return nil if value.is_a?(String) && value == 'MAIN'

      window = select_window(value)
      windows.delete(window) unless window.nil?
    end

    def delete_active_window
      return nil if windows.length == 1

      windows.pop
    end

    def select_window(value)
      result = nil
      if value.is_a?(Integer)
        windows.each do |window|
          if window.id == value
            result = window
            break
          end
        end
      end

      return result unless value.is_a?(String)

      windows.each do |window|
        if window.name == value
          result = window
          break
        end
      end
      result
    end

    def new_window(new_origin:, rows:, cols:, name: '', option: :simple)
      if option == :simple
        windows << SimpleWindow.new(
          name: name,
          id: windows.length,
          reference: main_window.win_origin,
          new_origin: new_origin,
          rows: rows,
          cols: cols
        )
      end

      if option == :scrolling
        windows << ScrollingWindow.new(
          name: name,
          id: windows.length,
          reference: main_window.win_origin,
          new_origin: new_origin,
          rows: rows,
          cols: cols
        )
      end

      windows[-1]
    end
  end
end
