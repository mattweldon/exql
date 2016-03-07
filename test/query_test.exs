defmodule Exql.QueryTest do
  use ExUnit.Case

  import Exql.Query

  test "build simple select statement" do
    query =
      with_table("people")

    assert query.sql == "select * from people"
  end

  test "build select statement with a where clause" do
    query =
      with_table("people")
      |> filter("id = @id", [id: 1])

    assert query.sql == "select * from people where id = @id"
    assert query.params == [id: 1]
  end

  test "build select statement with multiple where clauses" do
    query =
      with_table("people")
      |> filter("id = @id", [id: 1])
      |> filter("name = @name", [name: "john"])

    assert query.sql == "select * from people where id = @id and name = @name"
    assert query.params == [id: 1, name: "john"]
  end

  test "can execute with query struct and return values" do
    results =
      with_table("people")
      |> filter("id = @id", [id: 1])
      |> execute

    assert Enum.count(results) == 1

    results =
      with_table("people")
      |> execute

    assert Enum.count(results) == 2
  end

  test "can execute query returning a single result" do
    query =
      with_table("people")
      |> single

    assert query.sql == "select top 1 * from people"

    result = query |> execute

    assert result.id == 2
    assert result.name == "jane"
    assert result.email == "jane@bloggs.com"
  end

  test "can execute query returning the first result in the set" do
    query =
      with_table("people")
      |> first

    assert query.sql == "select * from people"

    result = query |> execute

    assert result.id == 2
    assert result.name == "jane"
    assert result.email == "jane@bloggs.com"
  end

  test "can execute query returning the last result in the set" do
    query =
      with_table("people")
      |> last

    assert query.sql == "select * from people"

    result = query |> execute

    assert result.id == 1
    assert result.name == "john"
    assert result.email == "john@doe.com"
  end
end
