defmodule Exql.Runner do

  def connect! do
    {:ok, pid} = connect
    pid
  end

  def connect do
    Application.get_env(:exql, :connection)
    |> Tds.Connection.start_link
  end

  def send_query(conn, query) do
    Tds.Connection.query(conn, query.sql, query.params |> create_params)
    |> Exql.Transformer.transform(query.rollup)
  end

  defp create_params(params) do
    Enum.map(params, fn({k, v}) ->
      %Tds.Parameter{name: "@#{Atom.to_string(k)}", value: v}
    end)
  end

end
