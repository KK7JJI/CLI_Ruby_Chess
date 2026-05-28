# frozen_string_literal: true

module CLIChess
  # console command mixin methods.
  module ConsoleMixins
    def win_origin(value)
      # expect "1;1"
      [':', ',', '|'].each do |punc|
        value = value.sub(punc, ';')
      end
      value.split(';').map { |coord| coord.to_i }
    end

    def return_message(node, msg: nil)
      ReturnMessage.new(parms: {
                          type: :message,
                          line: node.line,
                          start_pos: node.start_pos,
                          msg: msg
                        })
    end
  end
end
