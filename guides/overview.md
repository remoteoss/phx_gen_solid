# Overview

> Still early in development & subject to change

`mix phx.gen.solid` exists to generate the boilerplate usually required when
utilizing the SOLID principles, outlined below, in a larger phoenix project.
By default it provides fairly general templates for each of the handlers,
services, finders, and values. However, all of the templates are completely
overrideable.

## Currently Supported Generators

- `Mix.Tasks.Phx.Gen.Solid.Value` - used to generate a value
- `Mix.Tasks.Phx.Gen.Solid.Handler` - TODO
- `Mix.Tasks.Phx.Gen.Solid.Service` - TODO
- `Mix.Tasks.Phx.Gen.Solid.Finder` - TODO

## SOLID Principles

The best way to contain cyclomatic complexity is by employing SOLID principles whenever applicable:

> Single-responsibility principle - A class/module should only have a single responsibility

> Open-closed principle - Software entities should be open to extension but closed to modification

> Liskov Substitution principle - Objects in a program should be replaceable with instances of their subtypes without altering the correctness of that program.

> Interface Segregation principle - Many client-specific interfaces are better than one general-purpose interface.

> Dependency inversion principle - Abstractions over concretions

## 4 Patterns

A way to enforce the SOLID principles is by implementing a combination of 4
design patterns and their interactions to guide codebase scalability.

- Handlers
- Services
- Finders
- Values

![Pattern Interaction Map](assets/patterns.png)

### Handlers

Handlers are orchestators. They exist only to dispatch and compose. It orders
execution of tasks and/or fetches data to put a response back together.

**Do**

- Organize by business logic, domain, or sub-domain
- Orchestrate high level operations
- Command services, finders, values or other handlers
- Multiple public functions
- Keep controllers thin
- Make it easy to read
- Flow control (if, case, pattern match, etc.)

**Don't**

- Directly create/modify data structures
- Execute any read/write operations

Below is an example of a handler that creates a user, sends a notification, and
fetches some data.

```elixir
defmodule Remoteoss.Handler.Registration do
  alias Remoteoss.Accounts.Service.{CreateUser, SendNotification}
  alias Remoteoss.Accounts.Finder.SuperHeroName

  def setup_user(name) do
    with {:ok, user} <- CreateUser.call(name),
         :ok <- SendNotification.call(user),
         super_hero_details <- SuperHeroName.find(name) do
      {user, super_hero_details}
    else
      error ->
        error
    end
  end
end
```

### Services

Services are the execution arm. Services execute actions, write data, invoke
third party services, etc.

**Do**

- Organize by Application Logic
- Reusable across Handlers and other Services
- Commands services, finders and values
- Focuses on achieving one single goal
- Exposes a single public function: `call`
- Create/modify data structures
- Execute and take actions

**Don't**

- Use a service to achieve multiple goals
- Call Handlers
- If too big you need to break it into smaller services or your service is
  actually a handler

Below is an example of a service that creates a user.

```elixir
defmodule Remoteoss.Accounts.Service.CreateUser do
  alias Remoteoss.Accounts
  alias Remoteoss.Service.ActivityLog
  require Logger

  def call(name) do
    with {:ok, user} <- Accounts.create_user(%{name: name}),
         :ok <- ActivityLog.call(:create_user) do
      {:ok, user}
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, {:invalid_params, changeset.errors}}

      error ->
        error
    end
  end
end
```

### Finders

Finders fetch data, they don't mutate nor write, only read and present.

Non-complex database queries may also exist in Phoenix Contexts. A query can be
considered complex when their are several conditions for filtering, ordering,
and/or pagination. Rule of thumb is when passing a params or opts Map variable
to the function, a Finder is more appropriate.

**Do**

- Organized by Application Logic
- Reusable across Handlers and Services
- Focuses on achieving one single goal
- Exposes a single public function: `find`
- Read data structure
- Uses Values to return complex data
- Finders only read and look up data

**Don't**

- Call any services
- Create/modify data structures

Below is an example of a finder that finds a user.

```elixir
defmodule Remoteoss.Accounts.Finder.UserWithName do
  alias Remoteoss.Accounts

  def find(name) when is_binary(name) do
    case Accounts.get_user_by_name(name) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  def find(_), do: {:error, :invalid_name}
end
```

### Values

Values allow us to compose data structures such as responses,
intermediate objects, etc.

**Do**

- Organize by Application Logic
- Reusable across Handlers, Services, and Finders
- Focuses on composing a data structure
- Exposes a single public function: `build`
- Use composition to build through simple logic
- Only returns a `List` or a `Map`

**Don't**

- Call any Services, Handlers or Finders

Below is an example of a value that builds a user object to be used in a JSON
response. Note this utilizes the helper functions generated with
`Mix.Tasks.Phx.Gen.Solid.Value`.

```elixir
defmodule Remoteoss.Accounts.Value.User do
  alias Remoteoss.Value

  @valid_fields [:id, :name]

  def build(user, valid_fields \\ @valid_fields)

  def build(nil, _), do: nil

  def build(user, valid_fields) do
    user
    |> Value.init()
    |> Value.only(valid_fields)
  end
end
```
