defmodule <%= inspect service_update_module %> do
  @moduledoc """
  Updates a <%= schema.singular %>.
  """

  alias <%= inspect context.module %>

  def call(params) do 
    params
    |> <%= inspect context.alias %>.update_<%= schema.singular %>(params)
    |> handle_result()
  end 
  
  defp handle_result(result), do: result
end
