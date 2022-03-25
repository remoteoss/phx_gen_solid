defmodule Mix.Tasks.Phx.Gen.Solid.Service do
  @shortdoc "Generates C~~R~~UD services for a resource"

  @moduledoc """
  Generates C~~R~~UD Services for a resource.

      mix phx.gen.solid.value Accounts User users 

  The first argument is the context module followed by the schema module and its
  plural name.

  This creates the following services: 
  - `MyApp.Accounts.Service.CreateUser`
  - `MyApp.Accounts.Service.UpdateUser`
  - `MyApp.Accounts.Service.DeleteUser`

  For more information about the generated Services, see the [Overview](overview.html).
  """

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
      service_create_module: build_cud_module_name(context, schema, "Create"),
      service_update_module: build_cud_module_name(context, schema, "Update"),
      service_delete_module: build_cud_module_name(context, schema, "Delete")
    ]

    paths = Generator.paths()
    Generator.prompt_for_conflicts(context, &files_to_be_generated/1)
    Generator.copy_new_files(context, binding, paths, &files_to_be_generated/1)
  end

  defp files_to_be_generated(%Context{schema: schema} = context) do
    [
      {:eex, "service_create.ex",
       Path.join([context.dir, "services", "create_#{schema.singular}.ex"])},
      {:eex, "service_update.ex",
       Path.join([context.dir, "services", "update_#{schema.singular}.ex"])},
      {:eex, "service_delete.ex",
       Path.join([context.dir, "services", "delete_#{schema.singular}.ex"])}
    ]
  end

  defp build_cud_module_name(context, schema, action) do
    Module.concat([
      context.base_module,
      "#{inspect(context.alias)}",
      "Service",
      "#{action}#{inspect(schema.alias)}"
    ])
  end
end
