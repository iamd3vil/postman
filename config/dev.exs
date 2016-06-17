use Mix.Config

config :postman, Postman.Mailer,
  adapter: Bamboo.LocalAdapter

config :postman,
  purpose: :email,
  interaction: [:api, :rabbitmq],
  from_addr: "me@saratchandra.in",
  port: 9090
