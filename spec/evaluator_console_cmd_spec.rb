require_relative '../lib/interface/interface'

describe CLIChess::Evaluator do
  let(:display) { double('Display') }
  let(:tokenizer) { CLIChess::Tokenizer.new }
  let(:parser) { CLIChess::Parser.new }

  subject(:evaluator) { CLIChess::Evaluator.new(display: display) }

  def evaluate(statement)
    tokenizer.tokenize_line_input(statement: statement)
    parser.parse_line(
      token_list: tokenizer.tokens,
      statement: statement
    )
    evaluator.evaluate_line(
      parser_tree: parser.parser_tree,
      statement: statement
    )
    evaluator.result
  end

  describe 'new_window command' do
    [
      [
        "new_window name='test', type='simple', origin='1;1', rows=10, cols=20", CLIChess::ReturnMessage
      ],
      ['new_window', CLIChess::ErrorMsg],
      ["new_window name='test', origin='1;1', rows=10, cols=20", CLIChess::ErrorMsg],
      ["new_window name='test', type='simple', rows=10, cols=20", CLIChess::ErrorMsg],
      ["new_window name='test', type='simple', origin='1;1', cols=20", CLIChess::ErrorMsg],
      ["new_window name='test', type='simple', origin='1;1', rows=10", CLIChess::ErrorMsg],
      [
        "new_window name='test', type='simple', origin='1;1', cols='20', rows=10", CLIChess::ErrorMsg
      ],
      [
        "new_window name='test', type='simple', origin=1,1, cols=20, rows=10", CLIChess::ErrorMsg
      ]
    ].each do |statement, expectedclass|
      it "#{statement} returns #{expectedclass}" do
        allow(display).to receive(:new_window)
        allow(display).to receive(:refresh_display)
        result = evaluate(statement)
        expect(result).to be_a(expectedclass)
      end
    end
  end

  describe 'list_windows command' do
    [
      ['list_windows', CLIChess::ReturnMessage],
      ['list_windows size=10', CLIChess::ErrorMsg]
    ].each do |statement, expectedclass|
      it "#{statement} returns #{expectedclass}" do
        allow(display).to receive(:list_windows)
        allow(display).to receive(:refresh_display)
        result = evaluate(statement)
        expect(result).to be_a(expectedclass)
      end
    end
  end

  %w[close_window activate_window].each do |cmd|
    describe "#{cmd} command" do
      [
        ["#{cmd} name='WIN1'", CLIChess::ReturnMessage],
        ["#{cmd} id=2", CLIChess::ReturnMessage],
        ["#{cmd} 'WIN1'", CLIChess::ReturnMessage],
        ["#{cmd} 2", CLIChess::ReturnMessage]
      ].each do |statement, expectedclass|
        it "#{statement} returns #{expectedclass}" do
          allow(display).to receive(:delete_window)
          allow(display).to receive(:activate_window)
          allow(display).to receive(:refresh_display)
          result = evaluate(statement)
          expect(result).to be_a(expectedclass)
        end
      end

      [
        ["#{cmd} name='WIN1', id=2", CLIChess::ErrorMsg],
        ["#{cmd} name='WIN1", CLIChess::ErrorMsg],
        ["#{cmd} id=", CLIChess::ErrorMsg],
        ["#{cmd} WIN1 2", CLIChess::ErrorMsg]
      ].each do |statement, expectedclass|
        it "#{statement} returns #{expectedclass}" do
          allow(display).to receive(:delete_window)
          allow(display).to receive(:activate_window)
          allow(display).to receive(:refresh_display)
          result = evaluate(statement)
          expect(result).to be_a(expectedclass)
        end
      end
    end
  end
end
