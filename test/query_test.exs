defmodule Exql.QueryTest do
  use ExUnit.Case

  import Exql.Query

  test "build simple select statement" do
    query =
      with("people")
      |> return("*")

    assert query.sql == "select * from people"
  end

  test "build select statement with a where clause" do
    query =
      with("people")
      |> filter("id = @id", [id: 1])
      |> return("*")

    assert query.sql == "select * from people where id = @id"
    assert query.params == [id: 1]
  end

  test "can execute with query struct and return values" do
    results =
      with("people")
      |> filter("id = @id", [id: 1])
      |> return("*")
      |> execute

    assert Enum.count(results) == 1

    results =
      with("people")
      |> return("*")
      |> execute

    assert Enum.count(results) == 2
  end
end
