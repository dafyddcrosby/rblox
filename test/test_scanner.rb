# frozen_string_literal: true

require "test_helper"

class TestScanner < Minitest::Test
  def test_scanner_inputs
    [
      ["", []],
      [" ", []],
      ["\n", []],
      ["\t", []],
      ["\r", []],
      ["(\n", [:LEFT_PAREN]],
      [")\n", [:RIGHT_PAREN]],
      ["{\n", [:LEFT_BRACE]],
      ["}\n", [:RIGHT_BRACE]],
      [",\n", [:COMMA]],
      [".\n", [:DOT]],
      ["-\n", [:MINUS]],
      ["+\n", [:PLUS]],
      [";\n", [:SEMICOLON]],
      ["*\n", [:STAR]],
      ["!\n", [:BANG]],
      ["/\n", [:SLASH]],
      ["!=\n", [:BANG_EQUAL]],
      ["=\n", [:EQUAL]],
      ["==\n", [:EQUAL_EQUAL]],
      ["<\n", [:LESS]],
      ["<=\n", [:LESS_EQUAL]],
      [">\n", [:GREATER]],
      [">=\n", [:GREATER_EQUAL]],
      ["//comment\n", []],
      ["\"\n", []],
      ["\"foo\"\n", [:STRING]],
      ["1\n", [:NUMBER]],
      ["1.2\n", [:NUMBER]],
      ["apples\n", [:IDENTIFIER]],
      ["b4n4n4s_\n", [:IDENTIFIER]],
      ["orchid\n", [:IDENTIFIER]],
      ["and\n", [:AND]],
      ["class\n", [:CLASS]],
      ["else\n", [:ELSE]],
      ["false\n", [:FALSE]],
      ["for\n", [:FOR]],
      ["fun\n", [:FUN]],
      ["if\n", [:IF]],
      ["nil\n", [:NIL]],
      ["or\n", [:OR]],
      ["print\n", [:PRINT]],
      ["return\n", [:RETURN]],
      ["super\n", [:SUPER]],
      ["this\n", [:THIS]],
      ["true\n", [:TRUE]],
      ["var\n", [:VAR]],
      ["while\n", [:WHILE]],
    ].each do |input, output|
      assert_equal output,
                   RbLox::Scanner.new(input).scantokens.map(&:type),
                   [input, output]
    end
  end
end
