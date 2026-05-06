# frozen_string_literal: true

# project namespace
module CLIChess
  # evaluator resolve variable
  class ResolveVariables
    include ErrorMessage

    VALUE_CLASSES = {
      integer: IntegerValue,
      string: StringValue,
      boolean: BooleanValue
    }.freeze

    def resolve_variable(node, variables)
      unless variables.key?(node.value)
        return evaluator_error(node,
                               msg: "undefined variable \"#{node.value}\"")
      end

      klass = VALUE_CLASSES[variables[node.value][:type]]

      if klass
        return klass.new(parms: { type: variables[node.value][:type],
                                  value: variables[node.value][:value],
                                  start_pos: node.start_pos,
                                  line: node.line })
      end

      msg = "undefined value type for variable \"#{node.value}\", " \
            "type \"#{node.type}\""
      evaluator_error(node, msg: msg)
    end
  end
end
