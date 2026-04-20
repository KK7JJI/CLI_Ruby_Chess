# frozen_string_literal: true

# project namespace
module CLIChess
  # render the game in some way for visualization
  class RenderGame
    include Constants

    attr_reader :chessboard

    def initialize(chessboard)
      @chessboard = chessboard
    end

    def render(option: :game)
      return render_console if option == :console
      return render_text if option == :text

      nil
    end

    private

    def render_text
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

    def render_console
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
end
