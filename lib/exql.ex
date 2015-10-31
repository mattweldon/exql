defmodule Exql do

  def execute(sql) do
    Exql.Runner.connect!
    |> Tds.Connection.query(sql, [])
    |> Exql.Transformer.transform
  end

end
