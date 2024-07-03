defmodule HelloApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :hello_api,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [
        hello_api: [
          include_executables_for: [:unix],
          applications: [runtime_tools: :permanent],
          # steps: [:assemble, :tar]
          steps: [:assemble]
        ]
      ],
      default_release: :hello_api
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
      {:bandit, "~> 1.5"}
    ]
  end
end