defmodule OneSignal.Mixfile do
  use Mix.Project

  @description "Elixir wrapper of OneSignal"

  def project do
    [app: :one_signal,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     description: @description,
     package: package]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger],
     mod: {OneSignal, []}]
  end

  defp package do
    [maintainers: ["Takuma Yoshida"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/yoavlt/one_signal"},
    ]
  end

  defp deps do
    [
      {:poison, "~> 1.5"},
      {:httpoison, "~> 0.8.0"},
      {:ex_doc, "~> 0.8.0", only: :docs}
    ]
  end
end
