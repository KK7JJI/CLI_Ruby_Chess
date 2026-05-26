# frozen_string_literal: true

# project namespace

module CLIChess
  # command line tokenizer
  class Tokenizer
    include Serialize

    KEYWORDS = %w[
      new_window
      list_windows
      close_window
      activate_window
      move_window
      move
      to
      help
      reset
      insert
      remove
      capture
      reposition
      save
      exit
    ].freeze

    TYPES = {
      comment: /^(?<comment>#.*)/,
      whitespace: /^(?<whitespace>\s+)/,
      punctuation: /^(?<punctuation>[.()\[\]{},;:])/,
      comparison: /^(?<comparison><=|>=|==|!=|<|>)/,
      operator: %r{^(?<operator>[%+\-*/])},
      logical: /^(?<logical>&&|\|\||!)/,
      assignment: /^(?<assignment>=)/,
      string: /^(?<string>".+?"|'.+?')/,
      integer: /^(?<integer>\d+)/,
      boolean: /^(?<boolean>true|false)\b/,
      nil: /^(?<nil>null|nil)\b/,
      identifier: /^(?<identifier>[A-Za-z_]\w*)/
    }.freeze

    WITHOUT_TOKEN = %i[
      comment
      whitespace
    ].freeze

    attr_reader :tokens, :result, :eval_statement

    def initialize
      @eval_statement = nil
      @tokens = []
      @lines = []
      @col = 0
      @result = nil
    end

    def tokenize_line_input(statement: nil)
      self.eval_statement = statement
      self.tokens = []
      self.col = 0
      return nil if statement.nil?

      while statement.length.positive?
        tokenize(statement)

        if result.nil?
          msg = "SyntaxError, unexpected token \"#{eval_statement[col]}\""
          tokens << error_token(error_msg: msg)
          break
        end

        statement = consume(result, statement)
      end
    end

    def tokenize_file_input(read_from:, save_to: 'tokens.data')
      File.open(read_from, 'r') do |file|
        file.each_line do |statement|
          tokenize_line_input(statement: statement)
          lines << [statement, tokens]
        end
      end
      save_tokens(save: save_to)
    end

    def to_s
      msg = tokens.map { |token| token }
      msg.join("\n")
    end

    private

    attr_writer :eval_statement, :tokens, :result
    attr_accessor :col, :lines

    def save_tokens(save:)
      File.open(save, 'w') do |file|
        lines.each { |line| file.puts JSON.generate(line) }
      end
    end

    def tokenize(input_copy)
      self.result = nil
      TYPES.each_key do |token_type|
        self.result = match(input_copy, token_type)
        next if result.nil?

        unless WITHOUT_TOKEN.include?(token_type)
          tokens << new_token(token_type)
        end
        self.col += result.length
        break
      end
    end

    def consume(value, input_copy)
      input_copy.sub(value, '')
    end

    def match?(input, option)
      TYPES[option].match?(input)
    end

    def match(input, option)
      return unless match?(input, option)

      result = TYPES[option].match(input).named_captures[option.to_s]

      raise 'incorrect regular expression group name' if result.nil?

      result
    end

    def new_token(type)
      type = identifier_type if type == :identifier

      Token.new(
        type: type,
        name: result,
        line: lines.length + 1,
        col: col
      )
    end

    def error_token(error_msg: nil)
      Token.new(
        type: :error,
        name: error_msg,
        line: lines.length + 1,
        col: col
      )
    end

    def identifier_type
      return :keyword if KEYWORDS.include?(result)

      :variable
    end
  end
end
