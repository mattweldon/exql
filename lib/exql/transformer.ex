defmodule Exql.Transformer do

  def transform(results) do
    case results do
      {:ok, %Tds.Result{columns: cols, rows: rows}} ->
        Enum.map(rows, fn(row) ->
          List.zip([cols,row])
          |> to_map
        end)
    end
  end

  def to_map(list, acc \\ %{})
  def to_map([], acc), do: acc
  def to_map([{key, val}|rest], acc) do
    acc = Map.put(acc, String.to_atom(key), val)
    to_map(rest, acc)
  end

end
