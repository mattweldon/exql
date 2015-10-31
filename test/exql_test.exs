defmodule ExqlTest do
  use ExUnit.Case
  doctest Exql

  test "runs raw sql and returns sane results" do
    results = Exql.execute("select * from people")
    assert Enum.count(results) == 2
  end
end
