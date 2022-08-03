# frozen_string_literal: true

require "test_helper"

class TestScanner < Minitest::Test
  def test_scanner_inputs
    [
      ["", []],
      ["\n", []],
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
      ["!=\n", [:BANG_EQUAL]],
    ].each do |input, output|
      assert_equal output,
                   RbLox::Scanner.new(input).scantokens.map(&:type),
                   [input, output]
    end
  end
end
