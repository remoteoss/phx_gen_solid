Code.require_file("../../mix_helper.exs", __DIR__)

defmodule Mix.Tasks.Phx.Gen.Solid.ServiceTest do
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
                     Solid.Service.run(~w(accounts User users name:string))
                   end

      assert_raise Mix.Error, ~r/Expected the schema, "users", to be a valid module name/, fn ->
        Solid.Service.run(~w(User users name:string))
      end

      assert_raise Mix.Error, ~r/The context and schema should have different names/, fn ->
        Solid.Service.run(~w(Accounts Accounts users))
      end

      assert_raise Mix.Error, ~r/Invalid arguments/, fn ->
        Solid.Service.run(~w(Accounts.User users))
      end

      assert_raise Mix.Error, ~r/Invalid arguments/, fn ->
        Solid.Service.run(~w(Accounts User))
      end
    end)
  end

  test "generates create, update, delete services", config do
    in_tmp_project(config.test, fn ->
      Solid.Service.run(~w(Accounts User users name:string))

      assert_file("lib/phx_gen_solid/accounts/services/create_user.ex", fn file ->
        assert file =~ "defmodule PhxGenSolid.Accounts.Service.CreateUser"
        assert file =~ "alias PhxGenSolid.Accounts"

        assert file =~ """
                 def call(params) do
                   params
                   |> Accounts.create_user(params)
                   |> handle_result()
                 end
               """

        assert file =~ "defp handle_result(result), do: result"
      end)

      assert_file("lib/phx_gen_solid/accounts/services/update_user.ex", fn file ->
        assert file =~ "defmodule PhxGenSolid.Accounts.Service.UpdateUser"
        assert file =~ "alias PhxGenSolid.Accounts"

        assert file =~ """
                 def call(params) do
                   params
                   |> Accounts.update_user(params)
                   |> handle_result()
                 end
               """

        assert file =~ "defp handle_result(result), do: result"
      end)

      assert_file("lib/phx_gen_solid/accounts/services/delete_user.ex", fn file ->
        assert file =~ "defmodule PhxGenSolid.Accounts.Service.DeleteUser"
        assert file =~ "alias PhxGenSolid.Accounts"

        assert file =~ """
                 def call(params) do
                   params
                   |> Accounts.delete_user(params)
                   |> handle_result()
                 end
               """

        assert file =~ "defp handle_result(result), do: result"
      end)
    end)
  end
end
