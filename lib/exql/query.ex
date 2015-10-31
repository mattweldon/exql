defmodule Exql.Query do
  defstruct [
    pid: nil,
    sql: nil,
    params: [],
    scope: "",
    criteria: "",
    table: nil
  ]

  @doc """
  Outlines the table or view you want to query.
  """
  def with(table) do
    %Exql.Query{table: table} |> build_sql
  end

  @doc """
  Outlines the columns you wish to return.
  """
  def return(query, columns) do
    %{query | scope: columns} |> build_sql
  end

  @doc """
  Defines the where clause of your query.
  """
  def filter(query, criteria, params) do
    %{query | criteria: criteria, params: params} |> build_sql
  end

  def execute(query) do
    Exql.Runner.connect!
    |> Tds.Connection.query(query.sql, query.params |> create_params)
    |> Exql.Transformer.transform
  end


  @doc """
  Builds the final sql statement.
  """
  defp build_sql(query) do
    case query do
      %{criteria: ""} ->
        %{query | sql: "select #{query.scope} from #{query.table}"}
      _ ->
        %{query | sql: "select #{query.scope} from #{query.table} where #{query.criteria}"}
    end
  end

  defp create_params(params) do
    Enum.map(params, fn({k, v}) ->
      %Tds.Parameter{name: "@#{Atom.to_string(k)}", value: v}
    end)
  end
end
