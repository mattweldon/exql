defmodule Exql.Transformer do

  def transform(results) do
    case results do
      {:ok, %Tds.Result{columns: cols, rows: rows}} ->
        Enum.map(rows, fn(row) -> List.zip([cols,row]) end)
    end
  end

end
