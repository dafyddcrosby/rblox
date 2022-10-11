# frozen_string_literal: true

# See tool/GenerateAst.java

module RbLox
  class Expr; end # rubocop:disable Lint/EmptyClass

  # TODO: Call
  {
    Assign: %w[name value],
    Binary: %w[left operator right],
    Get: %w[object name],
    Grouping: %w[expression],
    Literal: %w[value],
    Logical: %w[left operator right],
    Set: %w[object name value],
    Super: %w[keyword method],
    This: %w[keyword],
    Unary: %w[operator right],
    Variable: %w[name],
  }.each do |k, v|
    const_set(k.to_sym, Class.new(RbLox::Expr))
    str = <<~RUBY
      attr_accessor #{v.map { |var| ":#{var}" }.join(", ")}
      def initialize(#{v.join(", ")})
        #{v.map { |var| "@#{var} = #{var}" }.join("\n")}
      end

      def accept(visitor)
        visitor.visit_#{k.downcase}_expr(self)
      end
    RUBY
    const_get(k.to_sym).class_eval(str)
  end

  class AstPrinter
    def print(expr)
      expr.accept(self)
    end

    def parenthesize(name, *exprs)
      "(#{name} #{exprs.map { |e| e.accept(self) }.join(" ")})"
    end

    def visit_literal_expr(expr)
      return "nil" if expr.value.nil?

      expr.value.to_s
    end

    def visit_unary_expr(expr)
      parenthesize expr.operator.lexeme, expr.right
    end

    def visit_binary_expr(expr)
      parenthesize expr.operator.lexeme, expr.left, expr.right
    end
  end
end
