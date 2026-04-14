# frozen_string_literal: true

require_relative '../lib/chess'

describe CLIChess::App do
  subject(:chess) { CLIChess::App.new }
  it 'basic unit test' do
    expect(chess.run(nil)).to eql(nil)
  end
end
