defmodule Exql.Sql do
  @moduledoc """
  Builds a SQL statement from a populated Exql.Query.
  """

  @doc """
  Main entrypoint for constructing a full SQL statement from a pipelined Query.
  """
  def construct(query) do
    "select #{query.scope} from #{query.table}#{where_statement(query)}"
  end

  @doc """
  Build up a WHERE clause from the Query criteria.
  """
  def where_statement(%{criteria: []}), do: ""
  def where_statement(%{criteria: criteria}) do
    flat_criteria = Enum.join(criteria, " and ")
    " where #{flat_criteria}"
  end



end
