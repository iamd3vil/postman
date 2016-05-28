defmodule Postman.Mixfile do
  use Mix.Project

  def project do
    [app: :postman,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :cowboy, :plug, :bamboo, :conform, :amqp],
     mod: {Postman, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:cowboy, "~> 1.0"},
     {:plug, "~> 1.1"},
     {:bamboo, "~> 0.5.0"},
     {:exrm, "~> 1.0", overridable: true},
     {:conform, "~> 2.0", overridable: true},
     {:conform_exrm, "~> 1.0"},
     {:amqp, "~> 0.1.4"}
    ]
  end
end
