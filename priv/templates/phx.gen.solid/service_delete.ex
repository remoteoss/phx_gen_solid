defmodule <%= inspect service_delete_module %> do
  @moduledoc """
  Deletes a <%= schema.singular %>.
  """

  alias <%= inspect context.module %>

  def call(params) do
    params
    |> <%= inspect context.alias %>.delete_<%= schema.singular %>(params)
    |> handle_result()
  end

  defp handle_result(result), do: result
end
