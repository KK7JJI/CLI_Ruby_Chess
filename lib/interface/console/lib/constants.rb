# frozen_string_literal: true

# project namespace
module CLIChess
  # describes a row, col location
  module Constants
    BOX = {
      v: "\u2502",
      h: "\u2500",
      tr: "\u2510",
      tl: "\u250c",
      br: "\u2518",
      bl: "\u2514",
      wl: "\u251c",
      wr: "\u2524",
      wt: "\u252c",
      wb: "\u2534",
      x: "\u253c"
    }.freeze

    VIDEO = {
      r: "\e[7m",
      n: "\e[0m",
      bold: "\e[1m",
      norm: "\e[0m",
      start_cursor_blink: "\e[?12h",
      stop_cursor_blink: "\e[?12l",
      show_cursor: "\e[?25h",
      hide_cursor: "\e[?25hl",
      clear_screen: "\e[2J",
      cursor_top_left: "\e[20;1H"
    }.freeze

    TEAM = {
      0 => { color: 'White', direction: 1 },
      1 => { color: 'Black', direction: -1 }
    }.freeze
  end
end
