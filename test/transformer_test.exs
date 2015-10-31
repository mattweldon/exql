Application.get_env(:exql, :connection)

defmodule Exql.TransformerTest do
  use ExUnit.Case

  test "downcases keys" do
    result = Exql.Transformer.to_map([{"CamelCaseKey", "value"}])
    assert result[:camelcasekey]
  end
end
