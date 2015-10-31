defmodule Exql do

  def execute(sql) do
    Exql.Runner.connect!
    |> Tds.Connection.query(sql, [])
    |> Exql.Transformer.transform
  end

  def execute(sql, params) do
    Exql.Runner.connect!
    |> Tds.Connection.query(sql, create_params(params))
    |> Exql.Transformer.transform
  end

  defp create_params(params) do
    Enum.map(params, fn({k, v}) ->
      %Tds.Parameter{name: "@#{Atom.to_string(k)}", value: v}
    end)
  end

end
