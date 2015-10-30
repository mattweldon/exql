defmodule Exql.Runner do

  def connect do
    Application.get_env(:exql, :connection)
    |> Tds.Connection.start_link
  end

end
