defmodule Exql.SqlFileTest do
  use ExUnit.Case
  import Exql.Query

  test "a single file is loaded" do
    cmd = sql_file_command(:simple, 1)
    assert cmd.sql == "select * from users where id=$1;"
    assert length(cmd.params) == 1
  end

end
