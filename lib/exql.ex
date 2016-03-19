defmodule Exql do
  use Application

  def start,  do: start(:normal, [])
  def start(type, args) do
    Exql.Supervisor.start_link(type, args)
  end
end
