defmodule <%= inspect service_create_module %> do
  @moduledoc """
  Creates a <%= schema.singular %>.
  """

  alias <%= inspect context.module %>

  def call(params) do 
    params
    |> <%= inspect context.alias %>.create_<%= schema.singular %>(params)
    |> handle_result()
  end 
  
  defp handle_result(result), do: result
end
