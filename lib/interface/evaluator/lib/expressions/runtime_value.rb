# frozen_string_literal: true

# project namespace
module CLIChess
  # evaluator literals; strings, integers, boolean values
  class RuntimeValue
    include ErrorMessage

    def runtime_value(node)
      type = node.type.to_sym
      parms = { type: type, value: node.value, start_pos: node.start_pos,
                line: node.line }
      return IntegerValue.new(parms: parms) if type == :integer
      return StringValue.new(parms: parms) if type == :string
      return BooleanValue.new(parms: parms) if type == :boolean

      evaluator_error(node, msg: "undefined value type #{type}")
    end
  end
end
