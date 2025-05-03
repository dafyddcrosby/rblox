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
        THIS TRUE VAR WHILE EOF ].each do |token|
      val = 1 << i
      const_set(token, val)
      lookup[val] = token.to_sym
      i += 1
    end
    LOOKUP = lookup

    # TODO: Could generate this from array and be clever ;-)
    KEYWORD_MAP = {
      "and" => RbLox::Tokens::AND,
      "class" => RbLox::Tokens::CLASS,
      "else" => RbLox::Tokens::ELSE,
      "false" => RbLox::Tokens::FALSE,
      "for" => RbLox::Tokens::FOR,
      "fun" => RbLox::Tokens::FUN,
      "if" => RbLox::Tokens::IF,
      "nil" => RbLox::Tokens::NIL,
      "or" => RbLox::Tokens::OR,
      "print" => RbLox::Tokens::PRINT,
      "return" => RbLox::Tokens::RETURN,
      "super" => RbLox::Tokens::SUPER,
      "this" => RbLox::Tokens::THIS,
      "true" => RbLox::Tokens::TRUE,
      "var" => RbLox::Tokens::VAR,
      "while" => RbLox::Tokens::WHILE,
    }.freeze
  end

  class Token < BasicObject
    include Tokens
    attr_accessor :lexeme

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
      @line = 1
    end

    def scantokens
      @scanner = ::StringScanner.new(@source)
      until @scanner.eos?
        t = case (c = @scanner.getch)
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
            when "="
              Token.new(match("=") ? EQUAL_EQUAL : EQUAL)
            when "<"
              Token.new(match("=") ? LESS_EQUAL : LESS)
            when ">"
              Token.new(match("=") ? GREATER_EQUAL : GREATER)
            when "\""
              string
            when "/"
              if match("/")
                @scanner.skip_until(/\n/)
                next
              else
                Token.new(SLASH)
              end
            when "\r", "\t", " "
              next
            when "\n"
              @line += 1
              next
            else
              if digit?(c)
                number(c)
              elsif alpha?(c)
                identifier(c)
              else
                # raise UnexpectedCharacter
                @has_errors = true
                next
              end
            end
        @tokens.append t

        # Move scanner pointer forward on
        @scanner.scan(/\s*/)
      end
      @tokens.append(Token.new(EOF))
      @tokens.compact # compact to deal with nil returns (should check has_errors)
    end

    def digit?(char)
      char.between?("0", "9")
    end

    def alpha?(char)
      char.between?("a", "z") ||
        char.between?("A", "Z") ||
        char == "_"
    end

    def alphanumeric?(char)
      alpha?(char) || digit?(char)
    end

    def identifier(char)
      # TODO: pull substring from scanner (save an allocate)
      string = char
      string << @scanner.getch while alphanumeric? @scanner.peek(1)

      type = KEYWORD_MAP[string]
      type ||= IDENTIFIER
      Token.new(type)
    end

    def number(char)
      # TODO: pull substring from scanner (save an allocate)
      string = char
      string << @scanner.getch while digit?(@scanner.peek(1))

      if @scanner.peek(1) == "." && digit?(@scanner.peek(2)[1])
        string << @scanner.getch
        string << @scanner.getch while digit?(@scanner.peek(1))
      end
      Token.new(NUMBER, string.to_f)
    end

    def string
      # TODO: pull substring from scanner (save an allocate)
      string = String.new
      while (@scanner.peek(1) != '"') && !@scanner.eos?
        string << @scanner.getch
        @lines += 1 if @scanner.peek(1) == "\n"
      end

      if @scanner.eos?
        # puts "unterminated line"
        return
      end

      # get trailing "
      @scanner.getch
      Token.new(STRING, string)
    end

    def match(expected)
      return false if @scanner.eos?
      return false if @scanner.peek(1) != expected

      @scanner.getch # move ahead a character
      true
    end
  end
end
