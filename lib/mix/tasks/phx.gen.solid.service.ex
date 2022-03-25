defmodule Mix.Tasks.Phx.Gen.Solid.Service do
  @shortdoc "Generates CRUD services for a resource"

  use Mix.Task

  alias Mix.Phoenix.Context
  alias Mix.Tasks.Phx.Gen

  @switches []

  @impl true
  def run(args) do
    if Mix.Project.umbrella?() do
      Mix.raise("mix phx.gen.solid can only be run inside an application directory")
    end

    {opts, parsed} = OptionParser.parse!(args, strict: @switches)

    # Don't pass along the opts
    {context, schema} = Gen.Context.build(parsed, __MODULE__)

    binding = [
      context: context,
      opts: opts,
      schema: schema,
      web_app_name: web_app_name(context),
      service_create_module:
        Module.concat([
          context.base_module,
          "#{inspect(context.alias)}",
          "Create#{inspect(schema.alias)}"
        ])
    ]

    paths = generator_paths()
    prompt_for_conflicts(context)
    copy_new_files(context, binding, paths)
  end

  # The paths to look for template files for generators.
  #
  # Defaults to checking the current app's `priv` directory and falls back to
  # phx_gen_solid's `priv` directory.
  defp generator_paths do
    [".", :phx_gen_solid, :phoenix]
  end

  defp web_app_name(%Context{} = context) do
    context.web_module
    |> inspect()
    |> Phoenix.Naming.underscore()
  end

  defp prompt_for_conflicts(context) do
    context
    |> files_to_be_generated()
    |> Mix.Phoenix.prompt_for_conflicts()
  end

  defp files_to_be_generated(%Context{schema: schema} = context) do
    [
      {:eex, "service_create.ex",
       Path.join([context.dir, "services", "create_#{schema.singular}.ex"])}
    ]
  end

  defp copy_new_files(%Context{} = context, binding, paths) do
    files = files_to_be_generated(context)
    Mix.Phoenix.copy_from(paths, "priv/templates/phx.gen.solid", binding, files)

    context
  end
end
