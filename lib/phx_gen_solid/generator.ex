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

  def raise_with_help(msg) do
    Mix.raise("""
    #{msg}

    mix phx.gen.solid.service and phx.gen.solid.value expect a context module
    name, followed by a singular and plural name of the generated resource,
    ending with any number of attributes.
    For example:

    mix phx.gen.solid.service Accounts User users name:string
    mix phx.gen.solid.value Accounts User users name:string

    The context serves as the API boundary for the given resource. Multiple
    resources may belong to a context and a resource may be split over distinct
    contexts (such as Accounts.User and Payments.User).
    """)
  end
end
