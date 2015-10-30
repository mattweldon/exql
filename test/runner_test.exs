defmodule Exql.RunnerTest do
  use ExUnit.Case

  test "can connect to the database using env config values" do
    assert {:ok, pid} = Exql.Runner.connect
  end
end
