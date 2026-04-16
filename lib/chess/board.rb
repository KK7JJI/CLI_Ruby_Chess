# frozen_string_literal: true

# namespace for the project.
module CLIChess
  # representation of the chessboard.
  class ChessBoard
    attr_accessor :board, :renderer

    def initialize(renderer: RenderGame.new(self), option: :game)
      @board = Array.new(8) { Array.new(8) }
      @renderer = renderer
      @option = option
      @board_rank = BoardRank.new
      @board_file = BoardFile.new
      @board_left_diagonal = BoardLeftDiagonal.new
      @board_right_diagonal = BoardRightDiagonal.new
    end

    def render_game
      renderer.render(option: option)
    end

    def clear_board
      self.board = Array.new(8) { Array.new(8) }
    end

    def occupied?(position)
      return false unless board[position.file][position.rank]

      true
    end

    def on_board?(position)
      return false if position.valid?

      true
    end

    def collect_pieces
      # return an array containing all chess pieces.
      result = []
      board.each do |file|
        file.each do |square|
          result << square if square
        end
      end
      result
    end

    def load_pieces(chess_pieces)
      # restore pieces to the board.
      clear_board
      chess_pieces.each do |piece|
        board[piece.position.file][piece.position.rank] = piece unless piece.ghost?
      end
    end

    def clear_ghost_pieces
      load_pieces(collect_pieces)
    end

    def rank_and_file(piece)
      return nil unless piece

      my_rank = board_rank.possible_moves(piece, self)
      my_file = board_file.possible_moves(piece, self)
      my_file + my_rank
    end

    def place(piece)
      file, rank = piece.position.to_a
      board[file][rank] = piece
    end

    def diagonals(piece)
      return nil unless piece

      result_left = board_left_diagonal.possible_moves(piece, self)
      result_right = board_right_diagonal.possible_moves(piece, self)
      result_left + result_right
    end

    def to_str
      to_s
    end

    def to_s
      msg = []
      board.each do |file|
        file.each do |square|
          msg << square.to_s
        end
      end
      msg.join("\n")
    end

    private

    attr_reader :option, :board_rank, :board_file,
                :board_left_diagonal, :board_right_diagonal
  end
end
