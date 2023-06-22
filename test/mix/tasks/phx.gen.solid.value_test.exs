Code.require_file("../../mix_helper.exs", __DIR__)

defmodule Mix.Tasks.Phx.Gen.Solid.ValueTest do
  use ExUnit.Case
  import MixHelper
  alias Mix.Tasks.Phx.Gen.Solid

  setup do
    Mix.Task.clear()
    :ok
  end

  test "invalid mix args", config do
    in_tmp_project(config.test, fn ->
      assert_raise Mix.Error,
                   ~r/Expected the context, "accounts", to be a valid module name/,
                   fn ->
                     Solid.Value.run(~w(accounts User users name:string))
                   end

      assert_raise Mix.Error, ~r/Expected the schema, "users", to be a valid module name/, fn ->
        Solid.Value.run(~w(User users name:string))
      end

      assert_raise Mix.Error, ~r/The context and schema should have different names/, fn ->
        Solid.Value.run(~w(Accounts Accounts users))
      end

      assert_raise Mix.Error, ~r/Invalid arguments/, fn ->
        Solid.Value.run(~w(Accounts.User users))
      end

      assert_raise Mix.Error, ~r/Invalid arguments/, fn ->
        Solid.Value.run(~w(Accounts User))
      end
    end)
  end

  test "generates value", config do
    in_tmp_project(config.test, fn ->
      Solid.Value.run(~w(Accounts User users name:string))

      assert_file("lib/phx_gen_solid/accounts/values/user.ex", fn file ->
        assert file =~ "defmodule PhxGenSolid.Accounts.Value.User"
        assert file =~ "alias PhxGenSolid.Value"
        assert file =~ "@user_fields [:name]"

        assert file =~ "def build(user, user_fields \\\\ @user_fields)"
        assert file =~ "def build(nil, _), do: nil"

        assert file =~ """
                 def build(user, user_fields) do
                   user
                   |> Value.init()
                   |> Value.only(user_fields)
                 end
               """
      end)

      # Because we didn't pass --helpers make sure we didn't generate it
      refute_file("lib/phx_gen_solid/value.ex")
    end)
  end

  test "creates helpers when option is passed", config do
    in_tmp_project(config.test, fn ->
      Solid.Value.run(~w(Accounts User users name:string --helpers))

      assert_file("lib/phx_gen_solid/value.ex", fn file ->
        assert file =~ "defmodule PhxGenSolid.Value"
      end)
    end)
  end
end
