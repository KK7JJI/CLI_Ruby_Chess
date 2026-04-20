# frozen_string_literal: true

# namespace for the project
module CLIChess
  # window which allows text scrolling
  class ScrollingWindow < BaseWindow
    attr_accessor :stored_text, :start_line, :page

    def cont_initialize
      @stored_text = []
      @start_line = 0
      @page = 0
    end

    def add_text(text, **kwargs)
      self.page = 0
      paragraphs = text.split("\n")
      self.stored_text = []
      paragraphs.each do |paragraph|
        self.stored_text += wrap_text(paragraph).reverse
      end
      show_page
    end

    def prev_page
      self.page -= 1
      self.page = 0 if self.page.negative?
      show_page
    end

    def next_page
      self.page += 1
      show_page
    end

    def show_page
      clear_window
      self.cmds = []
      add_borders

      col = 1 + win_origin[1]
      line = win_origin[0]
      start = (page * (rows - 2)) - 1
      stored_text[start, stored_text.length].each do |text|
        line += 1
        break if line >= win_origin[0] + rows - 1

        msg = "\e[#{line};#{col}H"

        msg += if line == win_origin[0] + rows - 2
                 '(cont.)'
               else
                 text.lstrip
               end

        cmds << msg
      end
    end

    private

    def wrap_text(text)
      return [] if text.nil?

      line = text[0, cols - 2]
      text = wrap_text(text[cols - 2, text.length])
      text << line
      text
    end
  end
end
