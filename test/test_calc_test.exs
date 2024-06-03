defmodule TestCalcTest do
  use ExUnit.Case
  doctest TestCalc

  test "greets the world" do
    assert TestCalc.hello() == :world
  end
end
