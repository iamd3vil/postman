use Mix.Config

config :postman, Postman.Mailer,
  adapter: Bamboo.LocalAdapter,
  api_key: System.get_env("MAILGUN_API_KEY"),
  domain: System.get_env("MAIL_DOMAIN")

config :postman,
  purpose: :email,
  interaction: [:api, :rabbitmq],
  from_addr: "info@skorpion.tech",
  port: 9090
