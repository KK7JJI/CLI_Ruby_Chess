require_relative 'chess'

class RenderGame
  BOX = {
    v: "\u2502",
    h: "\u2500",
    tr: "\u2510",
    tl: "\u250c",
    br: "\u2518",
    bl: "\u2514",
    wl: "\u251c",
    wr: "\u2524",
    wt: "\u252c",
    wb: "\u2534",
    x: "\u253c"
  }

  VIDEO = {
    r: "\e[7m",
    n: "\e[0m"
  }
  attr_accessor :chessboard

  def initialize(chessboard: nil)
    @chessboard = chessboard
  end

  def render_positions
    pieces = chessboard.collect_pieces
    white_pieces = pieces.filter { |piece| piece.team.zero? }
    black_pieces = pieces.filter { |piece| piece.team == 1 }

    msg = []
    msg << 'Player 1: (White)'
    white_pieces.sort.reverse_each do |piece|
      msg << "#{piece}: #{piece.position}"
    end
    msg << ''

    msg << 'Player 2: (Black)'
    black_pieces.sort.reverse_each do |piece|
      msg << "#{piece}: #{piece.position}"
    end
    msg.join("\n")
  end

  def render_game
    msg = []
    (0...8).to_a.each do |file|
      line = " #{('a'.ord + file).chr}"
      spacer = '  '
      (0...8).to_a.each do |rank|
        spacer += render_value(file, rank, '  ')
        line += render_value(file, rank, chessboard.board[file][rank])
      end
      spacer += BOX[:v]
      line += BOX[:v]
      msg << spacer
      msg << line
      msg << spacer
      msg << draw_mizzen
    end

    render = []
    render << draw_rank_numbers
    render << draw_top
    msg.each do |line|
      render << line
    end
    render[-1] = draw_bottom

    render.join("\n")
  end

  private

  def render_value(file, rank, value)
    vid = VIDEO[:n]
    vid = VIDEO[:r] if (file + rank).odd?
    content = ''
    content += BOX[:v]
    content += vid
    content += ' ' * 2
    content += vid
    content += value if value
    content += '  ' unless value
    content += vid
    content += ' ' * 2
    content += VIDEO[:n]
    content
  end

  def draw_top
    top = '  '
    top += "#{BOX[:tl]}#{BOX[:h] * 6}"
    7.times do
      top += "#{BOX[:wt]}#{BOX[:h] * 6}"
    end
    top += BOX[:tr]
    top
  end

  def draw_bottom
    bottom = '  '
    bottom += "#{BOX[:bl]}#{BOX[:h] * 6}"
    7.times do
      bottom += "#{BOX[:wb]}#{BOX[:h] * 6}"
    end
    bottom += BOX[:br]
    bottom
  end

  def draw_mizzen
    mizzen = '  '
    mizzen += "#{BOX[:wl]}#{BOX[:h] * 6}"
    7.times do
      mizzen += "#{BOX[:x]}#{BOX[:h] * 6}"
    end
    mizzen += BOX[:wr]
    mizzen
  end

  def draw_rank_numbers
    rank = '  '
    8.times do |idx|
      rank += '   '
      rank += "0#{idx + 1}"
      rank += '  '
    end
    rank += ' '
    rank
  end
end

chessboard = CLIChess::ChessBoard.new

pos1 = CLIChess::Position.new(board_pos: 'a1')
pos2 = CLIChess::Position.new(board_pos: 'd5')
pos3 = CLIChess::Position.new(board_pos: 'h8')
k1 = CLIChess::Knight.new(team: 0, position: pos1, board: chessboard)
k2 = CLIChess::Knight.new(team: 0, position: pos2, board: chessboard)
k3 = CLIChess::Knight.new(team: 1, position: pos3, board: chessboard)

pos4 = CLIChess::Position.new(board_pos: 'd1')
kg1 = CLIChess::King.new(team: 0, position: pos4, board: chessboard)

pos5 = CLIChess::Position.new(board_pos: 'd8')
kg2 = CLIChess::King.new(team: 1, position: pos5, board: chessboard)

chessboard.place(k1)
chessboard.place(k2)
chessboard.place(k3)
chessboard.place(kg1)
chessboard.place(kg2)

hints = k1.next_moves
hints.each do |hint|
  chessboard.place(hint)
end

hints = kg1.next_moves
hints.each do |hint|
  chessboard.place(hint)
end

puts RenderGame.new(chessboard: chessboard).render_game

chessboard.clear_ghost_pieces

puts RenderGame.new(chessboard: chessboard).render_game

puts RenderGame.new(chessboard: chessboard).render_positions

chessboard.clear_board
pos1 = CLIChess::Position.new(board_pos: 'g8')
b1 = CLIChess::Bishop.new(team: 0, position: pos1, board: chessboard)
chessboard.place(b1)

hints = b1.next_moves
hints.each do |hint|
  chessboard.place(hint)
end
puts RenderGame.new(chessboard: chessboard).render_game

chessboard.clear_board
pos1 = CLIChess::Position.new(board_pos: 'g2')
r1 = CLIChess::Rook.new(team: 0, position: pos1, board: chessboard)
chessboard.place(r1)

hints = r1.next_moves
hints.each do |hint|
  chessboard.place(hint)
end
puts RenderGame.new(chessboard: chessboard).render_game

chessboard.clear_board
pos1 = CLIChess::Position.new(board_pos: 'g7')
q1 = CLIChess::Queen.new(team: 0, position: pos1, board: chessboard)
chessboard.place(q1)

hints = q1.next_moves
hints.each do |hint|
  chessboard.place(hint)
end
puts RenderGame.new(chessboard: chessboard).render_game
