defmodule OneSignal.Mixfile do
  use Mix.Project

  @description "Elixir wrapper of OneSignal"

  def project do
    [
      app: :one_signal,
      version: "0.0.9",
      elixir: "~> 1.2",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: @description,
      package: package()
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application() do
    [applications: [:logger], mod: {OneSignal, []}, extra_applications: [:poison]]
  end

  defp package() do
    [
      maintainers: ["Takuma Yoshida"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/yoavlt/one_signal"}
    ]
  end

  defp deps() do
    [
      {:poison, "~> 3.1.0"},
      {:httpoison, "~> 1.8.0"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:ssl_verify_fun, ">= 1.1.0", manager: :rebar3, override: true}
    ]
  end
end
