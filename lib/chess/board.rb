# frozen_string_literal: true

# namespace for the project.
module CLIChess
  # representation of the chessboard.
  class ChessBoard
    attr_accessor :board

    def initialize
      # store pieces in board locations.
      # board[file][rank]
      # Array rows are board columns (file)
      # Array columns are board rows (rank)
      @board = Array.new(8) { Array.new(8) }
    end

    def clear_board
      self.board = Array.new(8) { Array.new(8) }
    end

    def occupied?(pos)
      return false unless board[pos.file][pos.rank]

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

    def file(position)
      board[position.file]
    end

    def rank(position)
      board.map { |file| file[position.rank] }
    end

    def place(piece)
      file, rank = piece.position.to_a
      board[file][rank] = piece
    end

    def diagonals(piece)
      return nil unless piece

      position = piece.position
      result_left = diagonal(position, :left)
      puts 'left'
      puts result_left.inspect
      puts ''
      result_right = diagonal(position, :right)
      puts 'right'
      puts result_right.inspect
      puts ''
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

    def diagonal(position, dir)
      arr = []
      file, rank = position.to_a
      puts "pos: rank: #{rank}, file: #{file}"
      x = [file, rank].min if dir == :right
      x = [board.length - file - 1, rank].min if dir == :left
      puts "min: #{x.inspect}"

      file += x if dir == :left
      file -= x if dir == :right
      rank -= x

      puts "start: rank: #{rank}, file: #{file}"
      while continue_diag?(rank, file)
        arr << [file, rank]
        file += 1 if dir == :right
        file -= 1 if dir == :left
        rank += 1
      end
      arr
    end

    def continue_diag?(rank, file)
      return false if file > 7
      return false if rank > 7
      return false if rank.negative?
      return false if file.negative?

      true
    end
  end
end
