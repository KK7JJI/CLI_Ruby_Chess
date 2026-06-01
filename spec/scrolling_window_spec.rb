require_relative '../lib/interface/interface'

describe CLIChess::ScrollingWindow do
  let(:vert) { 7 }
  let(:horz) { 3 }
  let(:cols) { 17 }
  let(:rows) { 7 }

  let(:metrics) do
    CLIChess::WindowMetrics.new(
      reference: [1, 1],
      new_origin: [vert, horz],
      rows: rows,
      cols: cols
    )
  end

  def wrap_text(text, cols)
    return [] if text.nil?

    line = text[0, cols - 2]
    text = wrap_text(text[cols - 2, text.length])
    text << line
    text
  end

  subject(:sw) do
    CLIChess::ScrollingWindow.new(
      name: 'Test1',
      id: 1,
      metrics: metrics,
      display: nil
    )
  end

  it '#add_new_text - initial' do
    text = "#{'A' * (cols - 2)}" * (rows - 3)
    text += "#{'B' * (cols - 2)}" * (rows - 3)
    text += "#{'C' * (cols - 2)}" * (rows - 3)

    sw.add_new_text(text)
    n = ((rows * 2) - 1)
    exp_result_first = "\e[#{vert + 3};#{horz + 2}H#{'A' * (cols - 2)}"
    expect(sw.cmds[n + 1]).to eql(exp_result_first)
    exp_result_last = "\e[#{vert + rows - 1};#{horz + 2}H(cont.)"
    expect(sw.cmds[-1]).to eql(exp_result_last)
  end

  it '#add_new_text - page 2' do
    text = "#{'A' * (cols - 2)}" * (rows - 3)
    text += "#{'B' * (cols - 2)}" * (rows - 3)
    text += "#{'C' * (cols - 2)}" * (rows - 3)

    sw.add_new_text(text)
    sw.next_page

    n = ((rows * 2) - 1)
    exp_result_first = "\e[#{vert + 3};#{horz + 2}H#{'B' * (cols - 2)}"
    expect(sw.cmds[n + 1]).to eql(exp_result_first)
    exp_result_last = "\e[#{vert + rows - 1};#{horz + 2}H(cont.)"
    expect(sw.cmds[-1]).to eql(exp_result_last)
  end

  it '#add_new_text - page 3' do
    text = "#{'A' * (cols - 2)}" * (rows - 3)
    text += "#{'B' * (cols - 2)}" * (rows - 3)
    text += "#{'C' * (cols - 2)}" * (rows - 3)

    sw.add_new_text(text)
    sw.next_page
    sw.next_page

    n = ((rows * 2) - 1)
    exp_result_first = "\e[#{vert + 3};#{horz + 2}H#{'C' * (cols - 2)}"
    expect(sw.cmds[n + 1]).to eql(exp_result_first)
    exp_result_last = "\e[#{vert + rows - 1};#{horz + 2}H(cont.)"
    expect(sw.cmds[-1]).to eql(exp_result_last)
  end

  it '#add_prev_text - page 2' do
    text = "#{'A' * (cols - 2)}" * (rows - 3)
    text += "#{'B' * (cols - 2)}" * (rows - 3)
    text += "#{'C' * (cols - 2)}" * (rows - 3)

    sw.add_new_text(text)
    sw.next_page
    sw.next_page
    sw.prev_page

    n = ((rows * 2) - 1)
    exp_result_first = "\e[#{vert + 3};#{horz + 2}H#{'B' * (cols - 2)}"
    expect(sw.cmds[n + 1]).to eql(exp_result_first)
    exp_result_last = "\e[#{vert + rows - 1};#{horz + 2}H(cont.)"
    expect(sw.cmds[-1]).to eql(exp_result_last)
  end

  it '#add_prev_text - page 1' do
    text = "#{'A' * (cols - 2)}" * (rows - 3)
    text += "#{'B' * (cols - 2)}" * (rows - 3)
    text += "#{'C' * (cols - 2)}" * (rows - 3)

    sw.add_new_text(text)
    sw.next_page
    sw.next_page
    sw.prev_page
    sw.prev_page

    n = ((rows * 2) - 1)
    exp_result_first = "\e[#{vert + 3};#{horz + 2}H#{'A' * (cols - 2)}"
    expect(sw.cmds[n + 1]).to eql(exp_result_first)
    exp_result_last = "\e[#{vert + rows - 1};#{horz + 2}H(cont.)"
    expect(sw.cmds[-1]).to eql(exp_result_last)
  end

  it '#add_prev_text - refresh' do
    text = "#{'A' * (cols - 2)}" * (rows - 3)
    text += "#{'B' * (cols - 2)}" * (rows - 3)
    text += "#{'C' * (cols - 2)}" * (rows - 3)

    sw.add_new_text(text)
    sw.next_page
    sw.next_page
    sw.prev_page
    sw.prev_page
    sw.refresh

    n = ((rows * 2) - 1)
    exp_result_first = "\e[#{vert + 3};#{horz + 2}H#{'A' * (cols - 2)}"
    expect(sw.cmds[n + 1]).to eql(exp_result_first)
    exp_result_last = "\e[#{vert + rows - 1};#{horz + 2}H(cont.)"
    expect(sw.cmds[-1]).to eql(exp_result_last)
  end
  it '#add_prev_text - rebuild_text' do
    text = "#{'A' * (cols - 2)}" * (rows - 3)
    text += "#{'B' * (cols - 2)}" * (rows - 3)
    text += "#{'C' * (cols - 2)}" * (rows - 3)

    sw.add_new_text(text)
    sw.next_page
    sw.next_page
    sw.prev_page
    sw.prev_page
    sw.rebuild_text
    sw.refresh

    n = ((rows * 2) - 1)
    exp_result_first = "\e[#{vert + 3};#{horz + 2}H#{'A' * (cols - 2)}"
    expect(sw.cmds[n + 1]).to eql(exp_result_first)
    exp_result_last = "\e[#{vert + rows - 1};#{horz + 2}H(cont.)"
    expect(sw.cmds[-1]).to eql(exp_result_last)
  end
end
