defmodule Postman.Mixfile do
  use Mix.Project

  def project do
    [app: :postman,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :cowboy, :plug, :bamboo, :conform, :conform_exrm, :amqp, :poolboy, :bamboo_smtp],
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
    [{:cowboy, "~> 1.1"},
     {:plug, "~> 1.4"},
     {:bamboo, "~> 0.8"},
     {:gen_smtp, "~> 0.11.0", override: true},
     {:bamboo_smtp, "~> 1.3"},
     {:exrm, "~> 1.0.6", overridable: true},
     {:conform, "~> 2.0", overridable: true},
     {:conform_exrm, "~> 1.0"},
     {:amqp, "~> 0.3.0"},
     {:poolboy, "~> 1.5"}
    ]
  end
end
