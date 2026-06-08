# frozen_string_literal: true

# namespace for the project
module CLIChess
  # window manager
  class Display
    include Constants
    include OutputMSG

    attr_accessor :main_window, :windows, :rows, :cols, :next_id

    def initialize
      @next_id = 0
      @rows, @cols = IO.console.winsize
      @windows = []
      @main_window = new_window(option: :simple,
                                name: 'MAIN',
                                reference: [1, 1],
                                new_origin: [0, 0],
                                cols: cols,
                                rows: (rows - 2))
      @active_window = @windows[-1]
    end

    def resize_window(value, rows, cols)
      # new_origin [row, col]
      window = select_window(value)
      return if window.nil?

      window.rows = rows
      window.cols = cols
      window.rebuild_text
    end

    def list_windows
      new_window(name: 'Windows',
                 new_origin: [2, 2],
                 rows: 20,
                 cols: 20,
                 option: :scrolling)

      msg = windows.map do |window|
        "#{format('%03d', window.id)}: #{window.name}"
      end
      active_window.add_new_text(msg.join("\n"))
    end

    def clear_screen
      print VIDEO[:cursor_top_left]
      print VIDEO[:clear_screen]
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

    def move_window(value, new_origin)
      # new_origin [row, col]
      window = select_window(value)
      return if window.nil?

      window.win_origin = window.screen_relative_coords(new_origin)
      window.rebuild_text
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

    def new_window(option: :simple, **kwargs)
      self.next_id += 1
      windows << new_simple_window(**kwargs) if option == :simple
      windows << new_scrolling_window(**kwargs) if option == :scrolling
      windows << new_interactive_window(**kwargs) if option == :interactive

      # return a handle to the active window.
      windows[-1]
    end

    def select_window(value)
      return select_by_id(value) if value.is_a?(Integer)
      return select_by_name(value) if value.is_a?(String)

      nil
    end

    private

    def window_metrics(**kwargs)
      WindowMetrics.new(
        reference: kwargs.fetch(:reference, nil) || main_window.win_origin,
        new_origin: kwargs[:new_origin],
        rows: kwargs[:rows],
        cols: kwargs[:cols]
      )
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
        if !window.name.nil? && window.name == value
          result = window
          break
        end
      end
      result
    end

    def new_simple_window(**kwargs)
      SimpleWindow.new(
        name: kwargs[:name],
        id: next_id,
        metrics: window_metrics(**kwargs),
        display: self
      )
    end

    def new_scrolling_window(**kwargs)
      ScrollingWindow.new(
        name: kwargs[:name],
        id: next_id,
        metrics: window_metrics(**kwargs),
        display: self
      )
    end

    def new_interactive_window(**kwargs)
      InteractiveWindow.new(
        name: kwargs[:name],
        id: next_id,
        metrics: window_metrics(**kwargs),
        display: self
      )
    end
  end
end
