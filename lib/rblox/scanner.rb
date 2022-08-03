# frozen_string_literal: true

require "strscan"

module RbLox
  module Tokens
    i = 0
    lookup = {}
    %w[ LEFT_PAREN RIGHT_PAREN LEFT_BRACE RIGHT_BRACE COMMA DOT MINUS
        PLUS SEMICOLON SLASH STAR BANG BANG_EQUAL EQUAL EQUAL_EQUAL
        GREATER GREATER_EQUAL LESS LESS_EQUAL IDENTIFIER STRING NUMBER
        AND CLASS ELSE FALSE FUN FOR IF NIL OR PRINT RETURN SUPER
        THIS TRUE VAR WHILE ].each do |token|
      val = 1 << i
      const_set(token, val)
      lookup[val] = token.to_sym
      i += 1
    end
    LOOKUP = lookup
  end

  class Token
    include Tokens
    def initialize(type, lexeme = "", literal = "", line = nil)
      @type = type
      @lexeme = lexeme
      @literal = literal
      @line = line
    end

    def to_s
      "#{@type} #{@lexeme} #{@literal}".strip
    end

    def type
      LOOKUP[@type]
    end
  end

  class Scanner
    include Tokens
    def initialize(source)
      @source = source
      @tokens = []
      @has_errors = false
      @scanner = nil
    end

    def scantokens
      @scanner = ::StringScanner.new(@source)
      until @scanner.eos?
        t = case @scanner.getch
            when "("
              Token.new(LEFT_PAREN)
            when ")"
              Token.new(RIGHT_PAREN)
            when "{"
              Token.new(LEFT_BRACE)
            when "}"
              Token.new(RIGHT_BRACE)
            when ","
              Token.new(COMMA)
            when "."
              Token.new(DOT)
            when "-"
              Token.new(MINUS)
            when "+"
              Token.new(PLUS)
            when ";"
              Token.new(SEMICOLON)
            when "*"
              Token.new(STAR)
            when "!"
              Token.new(match("=") ? BANG_EQUAL : BANG)
            when "\n"
              next
            else
              # raise UnexpectedCharacter
              @has_errors = true
              next
            end
        @tokens.append t
        # binding.irb

        # Move scanner pointer forward on
        @scanner.scan(/\s*/)
      end
      @tokens
    end

    def match(expected)
      return false if @scanner.eos?
      return false if @scanner.peek(1) != expected

      @scanner.getch # move ahead a character
      true
    end
  end
end
