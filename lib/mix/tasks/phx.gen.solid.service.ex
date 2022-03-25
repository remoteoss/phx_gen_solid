defmodule Mix.Tasks.Phx.Gen.Solid.Service do
  @shortdoc "Generates CRUD services for a resource"

  use Mix.Task

  alias Mix.Phoenix.Context
  alias Mix.Tasks.Phx.Gen
  alias PhxGenSolid.Generator

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
      web_app_name: Generator.web_app_name(context),
      service_create_module:
        Module.concat([
          context.base_module,
          "#{inspect(context.alias)}",
          "Create#{inspect(schema.alias)}"
        ])
    ]

    paths = Generator.paths()
    Generator.prompt_for_conflicts(context, &files_to_be_generated/1)
    Generator.copy_new_files(context, binding, paths, &files_to_be_generated/1)
  end

  defp files_to_be_generated(%Context{schema: schema} = context) do
    [
      {:eex, "service_create.ex",
       Path.join([context.dir, "services", "create_#{schema.singular}.ex"])}
    ]
  end
end
