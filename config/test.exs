use Mix.Config

config :postman, Postman.Mailer,
  adapter: Bamboo.TestAdapter

config :postman,
  purpose: :email,
  interaction: [:api, :rabbitmq],
  rabbitmq_pool_size: 1,
  from_addr: "me@saratchandra.in",
  port: 9090,
  rabbitmq_username: "user",
  rabbitmq_password: "password",
  rabbitmq_host: "rabbitmq"
