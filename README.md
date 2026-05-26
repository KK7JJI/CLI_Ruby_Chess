# CLI_Ruby_Chess

# REPL

## Tokenizer

## Parser

## Evaluator

## Nodes

# Console Windows

## Display

A simple windowing environment to house game displays

### #refresh_display

```
refresh_display
```

Refreshes **all** windows in the display. A refresh may be needed to render
changes to window contents after requesting changes.

### #active_window

```
prompt> x = active_window
```

returns a handle to the current active window.

### #refresh_active

```
prompt> refresh_active
```

Refreshes the contents of the active window. A refresh may be needed in
order to render changes to the window contents after requesting changes.

### #activate_window

by window name

```
prompt> activate_window('WIN1')
```

by window id

```
prompt> activate_window(1)
```

Activates a window either by window name or a numeric window id number.

### #delete_window

by window name

```
prompt> delete_window('WIN1')
```

by window id

```
prompt> delete_window(1)
```

Deletes a window either by window name or a numeric window id number.

### #delete_active_window

```
prompt> delete_active_window
```

Deletes the active window.

### #new_window

new_window(option: <option>, name: <name>, reference: <reference>,
new_origin: <new_origin>, cols: <cols>, rows: <rows>)

create a new window

Example:

```
prompt> new_window(option: :simple_window, name: "WIN1", reference: [1,1]
    new_origin: [5,5], cols: 20, rows: 30)
```

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
normally the reference coordinates are origin coordinates of the window
hosting the one created.

new_origin
defaults to [0,0]
locates the top left corner of the new window relative to the anchor window's
origin. [0,0] creates the new window such that the top left corner is
coincident with that of the anchor window, [1,2] positions it 1 row down
and 2 columns to the right.

cols
the number of horizontal columns in the window

rows
defaults to the number of vertical rows in the current console.
the number of rows in the window.

### rows

the number of rows in the current console

### cols

the number of columns in the current console

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

# developing a new console command definition

Define grammar first.

## console command

Console commands interact with the console windowing environment, i.e.
new_window, close_window, etc.

```
> new_window name='Window', origin='5:4', type='simple', rows=30, cols=20
> close_window name='Window
> list_windows
> activate_window name = 'Window
```

To define a new command:

### Tokenizer

`interface/lib/tokenizer/tokenizer.rb`
Tokenizer: add a new keyword to the keyword list.

### Parser

`interface/lib/parser/command/`
Parser: define a new command node. The command node begins with
a keyword token and is followed by variable assignments and values which
serve as command arguments.

The command node will contain logic which defines the expected order of
tokens and will return an error token is something unexpected is observed.

Nodes are called by class #call method i.e. `new_window.call`

`lib/parser/command.rb`
Register the new command

```
    # 1) lookup a command classname via keyword hash.
    COMMANDS = {
      'new_window' => NewWindowNode,
      'list_windows' => ListWindowsNode,
      'close_window' => CloseWindowNode
    }
```

`interface/lib/evaluator/lib/expressions/commands`
create a new command class object to define command behavior

`interface/lib/evaluator/lib/expressions/console_commands`
create a new command class object to define console_command behavior

`interface/lib/evaluator/evaluator.rb`

add required_relative path for new command class object.

```
require_relative 'lib/expressions/console_commands/list_windows'
require_relative 'lib/expressions/console_commands/close_window'
```

`interface/lib/evaluator/commands.rb`

add pointer to new command class object

`interface/lib/evaluator/console_commands.rb`

add pointer to new console_command class object
