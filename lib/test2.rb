require_relative 'chess'

chessboard = CLIChess::ChessBoard.new

chessboard.clear_board
pos1 = CLIChess::Position.new(board_pos: 'g7')
q1 = CLIChess::Queen.new(team: 0, position: pos1, board: chessboard)
chessboard.place(q1)

pos2 = CLIChess::Position.new(board_pos: 'b7')
p1 = CLIChess::Pawn.new(team: 1, position: pos2, board: chessboard)
chessboard.place(p1)

pos3 = CLIChess::Position.new(board_pos: 'h7')
p1 = CLIChess::Pawn.new(team: 1, position: pos3, board: chessboard)
chessboard.place(p1)

pos4 = CLIChess::Position.new(board_pos: 'h7')
p1 = CLIChess::Pawn.new(team: 1, position: pos3, board: chessboard)
chessboard.place(p1)

hints = q1.next_moves
hints.each do |hint|
  chessboard.place(hint)
end
puts chessboard.render_game

# the pawn should block the queens motion along the diagonal.
