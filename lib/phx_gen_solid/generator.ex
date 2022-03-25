defmodule PhxGenSolid.Generator do
  alias Mix.Phoenix.Context

  # The paths to look for template files for generators.
  #
  # Defaults to checking the current app's `priv` directory and falls back to
  # phx_gen_solid's `priv` directory.
  def paths do
    [".", :phx_gen_solid, :phoenix]
  end

  def web_app_name(%Context{} = context) do
    context.web_module
    |> inspect()
    |> Phoenix.Naming.underscore()
  end

  def copy_new_files(%Context{} = context, binding, paths, files_fn) do
    files = files_fn.(context)
    Mix.Phoenix.copy_from(paths, "priv/templates/phx.gen.solid", binding, files)

    context
  end

  def copy_new_files(%Context{} = context, binding, paths, files_fn, opts) do
    files = files_fn.(context, opts)
    Mix.Phoenix.copy_from(paths, "priv/templates/phx.gen.solid", binding, files)

    context
  end

  def prompt_for_conflicts(context, files_fn) do
    context
    |> files_fn.()
    |> Mix.Phoenix.prompt_for_conflicts()
  end

  def prompt_for_conflicts(context, files_fn, opts) do
    context
    |> files_fn.(opts)
    |> Mix.Phoenix.prompt_for_conflicts()
  end
end
