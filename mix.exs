defmodule HelloApi.MixProject do
  use Mix.Project

  # following https://github.com/zachdaniel/git_ops/blob/master/mix.exs
  @source_url "https://github.com/cao7113/hello-api-elixir"
  @version "0.1.2"

  # https://hexdocs.pm/mix/Mix.Project.html#module-configuration
  def project do
    [
      app: :hello_api,
      version: @version,
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      source_url: @source_url,
      releases: [
        hello_api: [
          include_executables_for: [:unix],
          applications: [runtime_tools: :permanent],
          # steps: [:assemble, :tar]
          steps: [:assemble]
        ]
      ],
      default_release: :hello_api,
      # test config
      test_config: "this is mix project config test value"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {HelloApi.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:bandit, "~> 1.5"},
      {:git_ops, "~> 2.6", only: [:dev], runtime: false}
    ]
  end
end
