# Silence mix generator output during tests
Mix.shell(Mix.Shell.Process)

defmodule MixHelper do
  import ExUnit.Assertions

  def tmp_path do
    Path.expand("../tmp", __DIR__)
  end

  defp random_string(len) do
    len |> :crypto.strong_rand_bytes() |> Base.encode64() |> binary_part(0, len)
  end

  def in_tmp_project(which, function) do
    path_root_folder = Path.join([tmp_path(), random_string(10)])
    path = Path.join([path_root_folder, to_string(which)])

    try do
      File.rm_rf!(path)
      File.mkdir_p!(path)

      File.cd!(path, fn ->
        File.touch!("mix.exs")

        File.write!(".formatter.exs", """
        [
          import_deps: [:phx_gen_solid],
          inputs: ["*.exs"]
        ]
        """)

        function.()
      end)
    after
      File.rm_rf!(path_root_folder)
    end
  end

  def assert_file(file) do
    assert File.regular?(file), "Expected #{file} to exist, but does not"
  end

  def refute_file(file) do
    refute File.regular?(file), "Expected #{file} to not exist, but it does"
  end

  def assert_file(file, match) do
    cond do
      is_list(match) ->
        assert_file(file, &Enum.each(match, fn m -> assert &1 =~ m end))

      is_binary(match) or is_struct(match, Regex) ->
        assert_file(file, &assert(&1 =~ match))

      is_function(match, 1) ->
        assert_file(file)
        match.(File.read!(file))

      true ->
        raise inspect({file, match})
    end
  end
end
