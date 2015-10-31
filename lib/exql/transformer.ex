defmodule Exql.Transformer do

  @doc """
  Transforms a Tds.Result into a list of maps representing the resultset.
  """
  def transform({:ok, %Tds.Result{columns: cols, rows: rows}}, :all) do
    Enum.map(rows, fn(row) -> transform(cols, row) end)
  end

  @doc """
  Transforms a Tds.Result into a single map representing the last item in the resultset.
  """
  def transform({:ok, %Tds.Result{columns: cols, rows: rows}}, :last) do
    row = List.last(rows)
    transform(cols, row)
  end

  @doc """
  Transforms a Tds.Result into a single map representing the first item in the resultset.
  """
  def transform({:ok, %Tds.Result{columns: cols, rows: rows}}, rollup) when is_atom(rollup) do
    row = List.first(rows)
    transform(cols, row)
  end

  @doc """
  Transforms a list of column names and a set of row data into a zipped map.
  """
  def transform(cols, row) do
    List.zip([cols,row])
    |> to_map
  end

  def to_map(list, acc \\ %{})
  def to_map([], acc), do: acc
  def to_map([{key, val}|rest], acc) do
    acc = Map.put(acc, String.to_atom(key), val)
    to_map(rest, acc)
  end

end
