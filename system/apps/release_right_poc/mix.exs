defmodule ReleaseRightPoc.MixProject do
  @moduledoc """
  Provides common configuration for the release right POC project.
  """

  use Mix.Project

  def project do
    [
      app: :release_right_poc,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.18-dev",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {ReleaseRightPoc.Application, []},
      extra_applications: [
        :logger,
        :runtime_tools,
        :observer,
        :os_mon
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 3.11.2"},
      {:commanded, "~> 1.4"},
      {:commanded_extreme_adapter, "~> 1.1"},
      {:logatron_core, in_umbrella: true},
    ]
  end
end
