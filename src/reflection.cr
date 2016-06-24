require "./reflection/*"

module Reflection
  abstract class Node
    abstract def ==(other : Node)
  end

  class Nop < Node
    def ==(other : Node)
      case other
      when Nop then true
      else          false
      end
    end
  end

  class Call < Node
    getter name : String
    getter receiver : Node
    getter args : Array(Node)
    getter named_args : Array(NamedArg)
    getter block : String

    def initialize(@name, @receiver, @args, @named_args, @block)
    end

    def ==(other : Node)
      case other
      when Call
        name == other.name &&
          receiver == other.receiver &&
          args == other.args &&
          named_args == other.named_args &&
          block == other.block
      else false
      end
    end
  end

  class NamedArg < Node
    def ==(other : Node)
      case other
      when NamedArg then false # FIXME
      else               false
      end
    end
  end

  class NumberLiteral < Node
    getter number : Int32

    def initialize(@number)
    end

    def ==(other : Node)
      case other
      when NumberLiteral then number == other.number
      else                    false
      end
    end
  end

  macro reflect_expression(expression)
    {% if expression.is_a? Call %}
      {% if expression.receiver.is_a?(Nop) %}
        %receiver = Reflection::Nop.new
      {% else %}
        %receiver = Reflection.reflect_expression({{ expression.receiver }})
      {% end %}

      %args = [] of Reflection::Node

      {% for arg in expression.args %}
        %args.push(Reflection.reflect_expression({{ arg }}))
      {% end %}

      %named_args = [] of Reflection::NamedArg
      {% if expression.named_args.is_a?(ArrayLiteral) %}
        {% for key, idx in expression.named_args %}
          %named_args.push Reflection::NamedArg.new(
            :{{ key.name.id }},
            Reflection.reflect_expression({{ expression.named_args[idx].value }})
          )
        {% end %}
      {% end %}

      %block = {{ expression.block.stringify }}

      Reflection::Call.new(
        {{ expression.name.stringify }},
        #{{ expression }},
        %receiver, %args, %named_args, %block
      )
    {% elsif expression.is_a? StringLiteral %}
      Reflection::StringLiteral.new({{expression.id.stringify}}.inspect, {{expression}})
    {% elsif expression.is_a? SymbolLiteral %}
      Reflection::SymbolLiteral.new({{expression}}.inspect, {{expression}})
    {% elsif expression.is_a? RangeLiteral %}
      Reflection::RangeLiteral.new({{expression}}.inspect, {{expression}})
    {% elsif expression.is_a?(NumberLiteral) %}
      Reflection::NumberLiteral.new({{expression}})
    {% else %}
      --- {{expression.class_name}}
      #Reflection::Node.build({{expression.id.stringify}}, {{expression}})
    {% end %}
  end

  # macro reflect_expression(exp)
  #   {% if expression.is_a? Call %}
  #     {% if expression.receiver.is_a?(Nop) %}
  #       %receiver = Microtest::PowerAssert::EmptyNode.new
  #     {% else %}
  #       %receiver = reflect_ast({{ expression.receiver }})
  #     {% end %}
  #     %args = [] of Microtest::PowerAssert::Node
  #     {% for arg in expression.args %}
  #       %args.push(reflect_ast({{ arg }}))
  #     {% end %}

  #     %named_args = [] of Microtest::PowerAssert::NamedArg
  #     {% if expression.named_args.is_a?(ArrayLiteral) %}
  #       {% for key, idx in expression.named_args %}
  #         %named_args.push Microtest::PowerAssert::NamedArg.new(
  #           :{{ key.name.id }},
  #           reflect_ast({{ expression.named_args[idx].value }})
  #         )
  #       {% end %}
  #     {% end %}

  #     %block = {{ expression.block.stringify }}

  #     Microtest::PowerAssert::Call.new(
  #       {{ expression.name.stringify }}, {{expression.stringify}},
  #       {{ expression }},
  #       %receiver, %args, %named_args, %block
  #     )
  #   {% elsif expression.is_a? StringLiteral %}
  #     Microtest::PowerAssert::TerminalNode.build({{expression.id.stringify}}.inspect, {{expression}})
  #   {% elsif %w(SymbolLiteral RangeLiteral).includes?(expression.class_name) %}
  #     Microtest::PowerAssert::TerminalNode.build({{expression}}.inspect, {{expression}})
  #   {% else %}
  #     Microtest::PowerAssert::TerminalNode.build({{expression.id.stringify}}, {{expression}})
  #   {% end %}
  # end
end
