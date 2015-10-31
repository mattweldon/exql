defmodule Exql.Sql do
  @moduledoc """
  Builds a SQL statement from a populated Exql.Query.
  """

  @doc """
  Main entry point for constructing a full SQL statement from a pipelined Query.
  """
  def construct(query) do
    "select #{rollup_statement(query)}#{query.scope} from #{query.table}#{where_statement(query)}"
  end

  @doc """
  Build the TOP statement from the Query.
  """
  def rollup_statement(%{rollup: :single}), do: "top 1 "
  def rollup_statement(%{rollup: _}), do: ""

  @doc """
  Build up a WHERE clause from the Query criteria.
  """
  def where_statement(%{criteria: []}), do: ""
  def where_statement(%{criteria: criteria}) do
    flat_criteria = Enum.join(criteria, " and ")
    " where #{flat_criteria}"
  end

end
