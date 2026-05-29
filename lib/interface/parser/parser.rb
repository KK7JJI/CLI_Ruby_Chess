# frozen_string_literal: true

require_relative 'lib/parser/output_msg'

require_relative 'lib/nodes/node'
require_relative 'lib/nodes/integer_node'
require_relative 'lib/nodes/string_node'
require_relative 'lib/nodes/variable_node'
require_relative 'lib/nodes/unary_op_node'
require_relative 'lib/nodes/binary_op_node'
require_relative 'lib/nodes/assignment_node'
require_relative 'lib/nodes/boolean_node'
require_relative 'lib/nodes/error_node'
require_relative 'lib/nodes/function_node'
require_relative 'lib/nodes/command_node'

require_relative 'lib/parser/new_error_node'

require_relative 'lib/parser/command/new_command_node'
require_relative 'lib/parser/command/window_node'
require_relative 'lib/parser/command/new_window_node'
require_relative 'lib/parser/command/list_windows_node'
require_relative 'lib/parser/command/close_window_node'
require_relative 'lib/parser/command/activate_window_node'
require_relative 'lib/parser/command/move_window_node'
require_relative 'lib/parser/command/refresh_display_node'
require_relative 'lib/parser/command/resize_window_node'

require_relative 'lib/parser/command'
require_relative 'lib/parser/tokens'
require_relative 'lib/parser/consume'
require_relative 'lib/parser/assignment'
require_relative 'lib/parser/primary/function'
require_relative 'lib/parser'
