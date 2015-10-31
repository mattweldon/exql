defmodule Exql.Transformer do

  @doc """
  Transforms a Tds.Result into a list of maps representing the resultset.
  """
  def transform(results, :all) do
    case results do
      {:ok, %Tds.Result{columns: cols, rows: rows}} ->
        Enum.map(rows, fn(row) ->
          transform(cols, row)
        end)
    end
  end

  @doc """
  Transforms a Tds.Result into a single map representing the relevant part of the resultset.
  """
  def transform(results, rollup) when is_atom(rollup) do
    case results do
      {:ok, %Tds.Result{columns: cols, rows: rows}} ->
        case rollup do
          :last ->
            row = List.last(rows)
          _ ->
            row = List.first(rows)
        end
        transform(cols, row)
    end
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
