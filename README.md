# phx.gen.sld

A Phoenix generator for Handlers, Services, Finders, and Values.

**Still early in development, some features may be missing. Expect bugs.**

## Overview

`mix phx.gen.sld` exists to generate the boilerplate usually required when
utilizing the SOLID principles, outlined below. By default it provides fairly
general templates for each of the handlers(WIP), services(WIP), finders(WIP),
and values. However, all of the templates are completely overrideable.

- Marcelo Lebre's talk - [Four patterns to save your codebase and your sanity](https://www.youtube.com/watch?v=xWqOR-cdIUQ)

### Installation

After running `mix phx.new`, `cd` into your application's directory (ex. `my_app`).

#### Basic Installation

1. Add `phx_gen_sld` to your list of dependencies in `mix.exs`

   ```elixir
   def deps do
     [
       {:phx_gen_sld, "~> 0.1", only: [:dev], runtime: false}
       ...
     ]
   end
   ```

2. Install and compile dependencies

   ```
   $ mix do deps.get, deps.compile
   ```

### Running the generators

From the root of your phoenix app, you can run the following generators

#### mix phx.gen.sld.value

This generator will build you a simple Value

    $ mix phx.gen.sld.value Accounts User users id slug name

This creates a Value in `MyApp.Accounts.Value.User`. By default the allowed
fields for this value will be the arguments you passed into the generator,
in this case, `@valid_fields [:id, :slug, :name]`.

To generate the helpers along with the value:

    $ mix phx.gen.sld.value Accounts User users id slug name --helpers

In addition to what gets created above, this will also generate the helpers
context with a default name of `MyApp.Value`.

To override the name of the module where the helpers exist:

    $ mix phx.gen.sld.value Accounts User users id slug name --value-context MyApp.Helpers.Value

This will override the name used in the generated value to alias the module
given.

#### mix phx.gen.sld.handler

TODO

#### mix phx.gen.sld.service

TODO

#### mix phx.gen.sld.finder

TODO
