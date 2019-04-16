defmodule PostmexTest do
  use ExUnit.Case
  doctest Postmex

  test "greets the world" do
    assert Postmex.hello() == :world
  end
end
