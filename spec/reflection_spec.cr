require "./spec_helper"

describe Reflection do
  test "reflects simple expression" do
    exp = Reflection.reflect_expression(4 + 5)
    exp = exp.as(Reflection::Call)

    assert exp.name == "+"
    assert exp.receiver == Reflection::NumberLiteral.new(4)
    assert exp.args[0] == Reflection::NumberLiteral.new(5)
  end

  test "reflects nested expressions" do
    exp = Reflection.reflect_expression(callit(a) * day)
    exp = exp.as(Reflection::Call)

    assert exp.name == "*"
    assert exp.receiver.as(Reflection::Call).name == "callit"
    assert exp.args[0].as(Reflection::Call).name == "day"
  end
end
