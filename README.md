# CLI_Ruby_Chess

# Console Windows

## Display

The windowing environment.

### rows

the number of rows in the current console

### cols

the number of columns in the current console

### refresh_display

refreshes the contents of each window.

### active_window

returns the active window.

### refresh_active

refreshes the contents of the active window

### activate_window(<value>)

activates a window either by name or integer ID

### delete_window(<value>)

deletes a window either by name or integer ID

### delete_active_window

deletes the active window

### new_window(option: <option>, name: <name>, reference: <reference>,

    new_origin: <new_origin>, cols: <cols>, rows: <rows>)

create a new window

options:
:simple_window
creates a window in which to display text.

:scrolling_window
creates a window in which to display text which can be scrolled vertically.

:interactive_window
creates a window with a command line interface.

reference
default [1,1], top left corner of the console.
this represent the reference coordinates for the window, [row, column]
normally the reference coordinates are those of the main window created when
display is instanced.

new_origin
defaults to [0,0]
locates the top left corner of the new window relative to the anchor window's
origin. [0,0] creates the new window such that the top left corner is
coincident with that of the anchor window, [1,2] positions it 1 row down
and 2 columns to the right.

cols
the number of columns in the window

rows
defaults to the number of rows less 2 in the current console.
the number of rows in the window

## Base Window

the window superclass

## Display Window

## Interactive Window

## Scrolling Window

## Simple Window

## Display
