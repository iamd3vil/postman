use Mix.Config

config :postman, Postman.Mailer,
  adapter: Bamboo.LocalAdapter

config :postman,
  purpose: :email,
  interaction: :api,
  from_addr: "info@skorpion.tech",
  port: 9090
