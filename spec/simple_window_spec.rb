require_relative '../lib/interface/interface'

# def new_simple_window(**kwargs)
#   SimpleWindow.new(
#     name: kwargs[:name],
#     id: next_id,
#     metrics: window_metrics(**kwargs),
#     display: self
#   )
# end

describe CLIChess::SimpleWindow do
  let(:vert) { 2 }
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

  subject(:sw) do
    CLIChess::SimpleWindow.new(
      name: 'Test1',
      id: 1,
      metrics: metrics,
      display: nil
    )
  end

  def fit_text_to_row(text)
    x = text.length - (cols - 2)
    text = text[x / 2, cols - 2] unless x <= 0
    text
  end

  def center_text_horizontal(sw, text)
    (sw.cols / 2) + sw.win_origin[1] - (text.length / 2)
  end

  def center_vertical(sw)
    (sw.rows / 2) + sw.win_origin[0]
  end

  it '#add_new_text -> center_in_window' do
    row = (rows / 2) + vert + 1
    (1...cols).to_a.each do |len|
      text = fit_text_to_row('A' * len)
      col = center_text_horizontal(sw, text)
      row = center_vertical(sw)
      sw.add_new_text(text, option: :center_in_window, row: row)
      expect(sw.cmds[-1]).to eq("\e[#{row};#{col}H#{text}")
    end
  end
  it '#add_new_text -> insert_at' do
    text = 'hello world'
    (1...(rows - 1)).to_a.each do |row|
      (1...cols).to_a.each do |col|
        sw.add_new_text(text, option: :insert_at, row: row, col: col)
        disp_text = text[0, cols - col - 1]
        expect(sw.cmds[-1]).to eq("\e[#{row + vert + 1};#{col + horz + 1}H#{disp_text}")
      end
    end
  end

  it '#add_new_text -> center_in_row' do
    (1...cols).to_a.each do |len|
      text = 'A' * len
      (1...(rows - 1)).to_a.each do |row|
        sw.add_new_text(text, option: :center_in_row, row: row)
        disp_text = fit_text_to_row(text)
        col = center_text_horizontal(sw, disp_text)
        expect(sw.cmds[-1]).to eq("\e[#{row + vert + 1};#{col}H#{disp_text}")
      end
    end
  end
  it '#add_new_text -> justify_left' do
    (1...cols).to_a.each do |len|
      text = 'A' * len
      (1...(rows - 1)).to_a.each do |row|
        disp_text = fit_text_to_row(text)
        sw.add_new_text(text, option: :justify_left, row: row)
        expect(sw.cmds[-1]).to eq("\e[#{row + sw.win_origin[0]};#{1 + sw.win_origin[1]}H#{disp_text}")
      end
    end
  end
  it '#add_new_text -> justify_right' do
    (1...cols).to_a.each do |len|
      text = 'A' * len
      (1...(rows - 1)).to_a.each do |row|
        disp_text = fit_text_to_row(text)
        col = sw.cols - disp_text.length + sw.win_origin[1] - 1
        sw.add_new_text(text, option: :justify_right, row: row)
        expect(sw.cmds[-1]).to eq("\e[#{row + sw.win_origin[0]};#{col}H#{disp_text}")
      end
    end
  end
end
