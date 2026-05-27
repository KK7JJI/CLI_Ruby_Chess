# CLI_Ruby_Chess
A chess program written in ruby for the command line.

# Console Windows

### #refresh_active

```
prompt> refresh_active
```

Refreshes the contents of the active window. A refresh may be needed in
order to render changes to the window contents after requesting changes.

### activate_window

```
prompt> activate_window 'WIN1'
prompt> activate_window 2
prompt> activate_window name='WIN1'
prompt> activate_window id=2
```

Activates a window either by window name or a numeric window id number.

see #activate_window

### close_window

delete/close a window by window name or id.  If no argument is given the active window will be closed.

examples:
```
prompt> close_window
prompt> close_window 'WIN1'
prompt> close_window 2
prompt> close_window name='WIN1'
prompt> close_window id=2
```

see #delete_window

### new_window

create a new window

```
prompt> new_window name='WIN1', type='simple', origin='2;2', cols=20, rows=30
```

valide types:
simple_window
creates a window in which to display text.

scrolling_window
creates a window in which to display text which can be scrolled vertically.

interactive_window
creates a window with a command line interface.

origin
locates the top left corner of the new window relative to the top left corner
of the display. [0,0] creates the new window such that the top left corner is
coincident with that of the display, [1,2] positions it 1 row down
and 2 columns to the right.

cols
the number of horizontal columns in the window

rows
defaults to the number of vertical rows in the current console.
the number of rows in the window.

### list_windows

creates a window listing the window names and ids of all open windows.

```
prompt> list_windows
```

```
┌───── Windows ────┐ 
│ │001: MAIN         
│ │002: WIN1         
│ │003: WIN2         
│ │004: WIN3         
│ │005: Windows      
│ │                  
```

# developing a new console command definition, notes

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
