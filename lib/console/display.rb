# frozen_string_literal: true

# namespace for the project
module CLIChess
  # window manager
  class Display
    attr_accessor :main_window, :windows, :rows, :cols

    def initialize
      @rows, @cols = IO.console.winsize
      @windows = []
      @main_window = new_window(option: :simple,
                                name: 'MAIN',
                                reference: [1, 1],
                                new_origin: [0, 0],
                                cols: cols,
                                rows: (rows - 2))
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
      return select_by_id(value) if value.is_a?(Integer)
      return select_by_name(value) if value.is_a?(String)

      nil
    end

    def select_by_id(value)
      result = nil
      windows.each do |window|
        if window.id == value
          result = window
          break
        end
      end
      result
    end

    def select_by_name(value)
      result = nil
      windows.each do |window|
        if window.name == value
          result = window
          break
        end
      end
      result
    end

    def new_window(option: :simple, **kwargs)
      windows << new_simple_window(**kwargs) if option == :simple
      windows << new_scrolling_window(**kwargs) if option == :scrolling
      windows << new_interactive_window(**kwargs) if option == :interactive

      windows[-1]
    end

    def window_metrics(**kwargs)
      WindowMetrics.new(
        reference: kwargs.fetch(:reference, nil) || main_window.win_origin,
        new_origin: kwargs[:new_origin],
        rows: kwargs[:rows],
        cols: kwargs[:cols]
      )
    end

    def new_simple_window(**kwargs)
      SimpleWindow.new(
        name: kwargs[:name],
        id: windows.length,
        metrics: window_metrics(**kwargs),
        display: self
      )
    end

    def new_scrolling_window(**kwargs)
      ScrollingWindow.new(
        name: kwargs[:name],
        id: windows.length,
        metrics: window_metrics(**kwargs),
        display: self
      )
    end

    def new_interactive_window(**kwargs)
      InteractiveWindow.new(
        name: kwargs[:name],
        id: windows.length,
        metrics: window_metrics(**kwargs),
        display: self
      )
    end
  end
end
