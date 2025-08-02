defmodule TamnoonTtt.MixProject do
  use Mix.Project

  def project do
    [
      app: :tamnoon_ttt,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {TamnoonTtt.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tamnoon, "~> 1.0.0-rc.1"}
    ]
  end
end
