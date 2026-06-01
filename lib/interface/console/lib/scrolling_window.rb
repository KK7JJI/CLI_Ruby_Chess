# frozen_string_literal: true

# namespace for the project
module CLIChess
  # window which allows text scrolling
  class ScrollingWindow < DisplayWindow
    attr_accessor :stored_text, :start_line, :page, :initial_text

    def cont_initialize
      @stored_text = []
      @initial_text = ''
      @start_line = 0
      @page = 0
    end

    def add_new_text(text, options: nil)
      self.initial_text = text
      self.page = 0
      add_text
    end

    def rebuild_text
      self.cmds = []
      add_borders
      add_text
    end

    def show_file(file: filename)
      add_new_text(read_file(file: file), {})
    end

    def prev_page
      self.page -= 1
      self.page = 0 if self.page.negative?
      clear_window
      self.cmds = []
      add_borders
      update_text_display_commands
    end

    def next_page
      self.page += 1
      clear_window
      self.cmds = []
      add_borders
      update_text_display_commands
    end

    def refresh
      print "\e7"
      clear_window
      cmds.each do |cmd|
        print cmd
      end
      print "\e8"
    end

    private

    def update_text_display_commands
      col = 1 + win_origin[1]
      line = 0
      start = page.zero? ? 0 : (page * (rows - 2 - 1))

      stored_text[start, stored_text.length].each do |text|
        line += 1
        break if line >= rows - 1

        cursor = "\e[#{line + win_origin[0]};#{col}H"

        msg = if line == rows - 2
                '(cont.)'
              else
                text.lstrip
              end

        cmds << "#{cursor}#{msg}"
      end
    end

    def add_text
      paragraphs = initial_text.split("\n")
      self.stored_text = []
      paragraphs.each do |paragraph|
        self.stored_text += wrap_text(paragraph).reverse
      end
      update_text_display_commands
    end

    def wrap_text(text)
      return [] if text.nil?

      line = text[0, cols - 2]
      text = wrap_text(text[cols - 2, text.length])
      text << line
      text
    end

    def file_text(file: filename)
      read_file(file: file)
    end

    def read_file(file: filename)
      return "#{file} does not exist." unless File.exist?(filename)
      return "#{file} is not a file." unless File.file?(filename)
      return "#{file} permission denied." unless File.readable?(filename)

      File.read(file)
    end
  end
end
