# frozen_string_literal: true

require 'io/console'
require_relative 'docs'
require_relative 'interface/interface'

disp = CLIChess::Display.new
disp.main_window.add_new_text('Hello World', option: :center_in_window)

disp.new_window(name: 'WIN1',
                new_origin: [3, 3],
                rows: 20,
                cols: 40,
                option: :simple)

disp.active_window.add_new_text('Hi there WIN1', option: :center_in_window)
disp.refresh_display

disp.new_window(name: 'WIN2',
                new_origin: [5, 5],
                rows: 20,
                cols: 40,
                option: :simple)

disp.active_window.add_new_text('Hi there WIN2!', option: :center_in_window)
disp.refresh_display

disp.activate_window('WIN1')
disp.refresh_display

disp.activate_window('WIN2')
disp.active_window.add_new_text('Hi Steve', option: :center_in_row, row: 1)
disp.active_window.add_new_text('Hi Steve', option: :center_in_row, row: 0)
disp.refresh_display

disp.new_window(name: 'WIN3',
                new_origin: [3, 3],
                rows: 20,
                cols: 10,
                option: :scrolling)

cols = 10
rows = 20
text = "#{'A' * (cols - 2)}" * (rows - 3)
text += "#{'B' * (cols - 2)}" * (rows - 3)
text += "#{'C' * (cols - 2)}" * (rows - 3)

disp.active_window.add_new_text(text)
disp.refresh_display

# disp.list_windows
# disp.refresh_display

# disp.activate_window('WIN3')
# disp.refresh_display

# disp.active_window.next_page
# disp.active_window.refresh

# disp.active_window.next_page
# disp.refresh_display

# disp.delete_window(4)
# disp.refresh_display

# disp.activate_window('WIN2')
# disp.refresh_display

# disp.move_window(3, [20, 6])
# disp.refresh_display

# moves Windows
# disp.move_window(5, [20, 20])
# disp.refresh_display

disp.new_window(name: 'WIN5',
                new_origin: [disp.rows - 8 - 3, 1],
                rows: 8,
                cols: disp.cols - 2,
                option: :interactive)
disp.refresh_display
disp.active_window.user_input

print "\e[1;1H"
