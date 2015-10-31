defmodule ExqlTest do
  use ExUnit.Case
  doctest Exql

  test "runs raw sql and returns sane results" do
    results = Exql.execute("select * from people")
    assert Enum.count(results) == 2
  end

  test "runes raw sql with params" do
    results = Exql.execute("select * from people where id = @user_id", [user_id: 1])
    assert Enum.count(results) == 1
  end
end
