defmodule Exql.Runner do

  def connect! do
    {:ok, pid} = connect
    pid
  end
  
  def connect do
    Application.get_env(:exql, :connection)
    |> Tds.Connection.start_link
  end

end
