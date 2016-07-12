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
    [applications: [:logger, :cowboy, :plug, :bamboo, :conform, :amqp, :poolboy, :bamboo_smtp],
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
     {:bamboo, github: "thoughtbot/bamboo", override: true},
     {:gen_smtp, "~> 0.11.0", override: true},
     {:bamboo_smtp, "~> 1.0"},
     {:exrm, "~> 1.0.6", overridable: true},
     {:conform, "~> 2.0", overridable: true},
     {:conform_exrm, "~> 1.0"},
     {:amqp_client, git: "https://github.com/jbrisbin/amqp_client.git", override: true},
     {:amqp, "~> 0.1.4"},
     {:poolboy, "~> 1.5"}
    ]
  end
end
