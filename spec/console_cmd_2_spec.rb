require_relative '../lib/interface/interface'

describe CLIChess::Evaluator do
  let(:display) { instance_double('Display') }
  let(:tokenizer) { CLIChess::Tokenizer.new }
  let(:parser) { CLIChess::Parser.new }

  let(:win_cols) { 20 }
  let(:win_rows) { 20 }
  let(:win_origin) { [2, 3] }

  let(:metrics) do
    CLIChess::WindowMetrics.new(
      reference: [1, 1],
      new_origin: win_origin,
      rows: win_rows,
      cols: win_cols
    )
  end

  let(:scrolling_win) do
    CLIChess::ScrollingWindow.new(
      name: 'TEST',
      id: 2,
      metrics: metrics,
      display: display
    )
  end

  let(:simple_win) do
    CLIChess::SimpleWindow.new(
      name: 'TEST',
      id: 3,
      metrics: metrics,
      display: display
    )
  end

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

  [
    ['add_text name="TEST", text="Hello World"', CLIChess::ReturnMessage],
    ['add_text id=2, text="Hello World"', CLIChess::ReturnMessage]
  ].each do |statement, expectedclass|
    it "#{statement} returns #{expectedclass} on scrolling window" do
      allow(display).to receive(:select_window).and_return(scrolling_win)
      allow(display).to receive(:refresh_display)
      cmd = "new_window name='TEST', origin='#{win_origin}', "
      cmd += "rows='#{win_rows}', cols='#{win_cols}'"
      evaluate(cmd)
      result = evaluate(statement)
      expect(result).to be_a(expectedclass)
      expect(result.to_s).to eq('add_text executed.')
    end
  end

  [
    ['add_text name="TEST", text="Hello World", option="center_window"', CLIChess::ReturnMessage],
    ['add_text id=2, text="Hello World", option="center_window"', CLIChess::ReturnMessage],
    ['add_text id=2, text="Hello World", option="center_row", row=5', CLIChess::ReturnMessage]
  ].each do |statement, expectedclass|
    it "#{statement} returns #{expectedclass} on simple window" do
      allow(display).to receive(:select_window).and_return(simple_win)
      allow(display).to receive(:refresh_display)
      cmd = "new_window name='TEST', origin='#{win_origin}', "
      cmd += "rows='#{win_rows}', cols='#{win_cols}'"
      evaluate(cmd)
      result = evaluate(statement)
      expect(result).to be_a(expectedclass)
      expect(result.to_s).to eq('add_text executed.')
    end
  end
end
