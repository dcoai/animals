defmodule Animals.MixProject do
  use Mix.Project

  def project do
    [
      app: :animals,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def escript() do
    [main_module: Animals.CLI]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.4"},
      {:enquirer, "~> 0.1.0"}
    ]
  end
end
