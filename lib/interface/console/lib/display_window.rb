# frozen_string_literal: true

# namespace for the project
module CLIChess
  # superclass for console windows
  class DisplayWindow < BaseWindow
    include Constants

    def cont_initialize
      raise NotImplementedError, '#cont_initialize must be defined.'
    end

    def add_new_text(text, **kwargs)
      raise NotImplementedError, '#add_new_text must be defined.'
    end

    def refresh
      clear_window
      cmds.each do |cmd|
        print cmd
      end
    end
  end
end
