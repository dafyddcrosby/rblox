# frozen_string_literal: true

require "test_helper"

module RbLox
  class TestAstParser < Minitest::Test
    def test_literal
      assert_equal "45.67",
                   AstPrinter.new.print(Literal.new(45.67))
    end

    def test_unary
      assert_equal "(- 123)",
                   AstPrinter.new.print(
                     Unary.new(
                       Token.new(Tokens::MINUS, "-", nil, 1),
                       Literal.new(123)
                     )
                   )
    end

    def test_binary
      assert_equal "(+ 2 3)",
                   AstPrinter.new.print(
                     Binary.new(
                       Literal.new(2),
                       Token.new(Tokens::PLUS, "+", nil, 1),
                       Literal.new(3)
                     )
                   )
    end
  end
end
