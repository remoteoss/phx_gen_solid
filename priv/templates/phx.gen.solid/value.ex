defmodule <%= inspect value_module %> do
  @moduledoc """
  The <%= schema.singular %> value.
  """
  alias <%= inspect value_context %>

  @<%= schema.singular %>_fields <%= inspect value_fields %>

  def build(<%= schema.singular %>, <%= schema.singular %>_fields \\ @<%= schema.singular %>_fields)

  def build(nil, _), do: nil

  def build(<%= schema.singular %>, <%= schema.singular %>_fields) do
    <%= schema.singular %>
    |> Value.init()
    |> Value.only(<%= schema.singular %>_fields)
  end
end
