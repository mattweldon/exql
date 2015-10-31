defmodule Exql.Query do
  defstruct [
    pid: nil,
    sql: nil,
    params: [],
    scope: "",
    criteria: [],
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
    %{query | criteria: query.criteria ++ [criteria], params: query.params ++ params} |> build_sql
  end

  @doc """
  Connects to the database, executes the given query and returns the results.
  """
  def execute(query) do
    Exql.Runner.connect!
    |> Exql.Runner.send_query(query)
    |> Exql.Transformer.transform
  end

  @doc """
  Builds the final sql statement.
  """
  defp build_sql(query) do
    case query do
      %{criteria: []} ->
        %{query | sql: "select #{query.scope} from #{query.table}"}
      _ ->
        flat_criteria = Enum.join(query.criteria, " and ")
        %{query | sql: "select #{query.scope} from #{query.table} where #{flat_criteria}"}
    end
  end
  
end
