defmodule HelloApi.MixProject do
  use Mix.Project

  # following https://github.com/zachdaniel/git_ops/blob/master/mix.exs
  @source_url "https://github.com/cao7113/hello-api-elixir"
  @version "0.2.3"

  # https://hexdocs.pm/mix/Mix.Project.html#module-configuration
  def project do
    [
      app: :hello_api,
      version: @version,
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      source_url: @source_url,
      releases: [
        hello_api: [
          include_executables_for: [:unix],
          applications: [runtime_tools: :permanent],
          # cookie: :crypto.strong_rand_bytes(40),
          # cookie: System.fetch_env!("RELEASE_COOKIE"),
          cookie: "cookie-value-set-in-mix-exs-project-function",
          steps: release_steps(System.get_env("RELEASE_TAR"))
        ]
      ],
      default_release: :hello_api,
      # test config
      test_config: "this is the value of mix.project.test_config"
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
      {:bandit, "~> 1.7"},
      {:git_ops, "~> 2.8", only: [:dev], runtime: false}
    ]
  end

  defp release_steps(need_tar) when need_tar in [nil, ""], do: [:assemble]
  defp release_steps(_), do: [:assemble, :tar]
end
