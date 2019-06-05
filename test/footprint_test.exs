defmodule FootprintTest do
  use ExUnit.Case
  doctest Footprint

  test "greets the world" do
    assert Footprint.hello() == :world
  end
end
