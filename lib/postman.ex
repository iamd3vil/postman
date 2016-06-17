defmodule Postman do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    purpose = Application.get_env(:postman, :purpose)
    interactions = Application.get_env(:postman, :interaction)
    # Adding children dynamically according to the config
    children = interactions
    |> Enum.reduce([], fn(interaction, acc) ->
      get_children(acc, purpose, interaction)
    end)

    opts = [strategy: :one_for_one, name: Postman.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp get_children(children, :email, :api) do
    put_plug_worker(children)
  end

  defp get_children(children, :email, :rabbitmq) do
    put_rabbitmq_worker(children)
  end

  defp put_plug_worker(children) do
    port = Application.get_env(:postman, :port)
    children ++ [Plug.Adapters.Cowboy.child_spec(:http, Postman.ApiPlug, [], port: port)]
  end

  defp put_rabbitmq_worker(children) do
    import Supervisor.Spec, warn: false

    rabbitmq_pool_opts = [
      name: {:local, :rabbitmq_pool},
      worker_module: Postman.RabbitmqWorker,
      size: Application.get_env(:postman, :rabbitmq_pool_size) || 10,
      max_overflow: 5
    ]
    username = Application.get_env(:postman, :rabbitmq_username) || "guest"
    password = Application.get_env(:postman, :rabbitmq_password) || "guest"
    {:ok, conn} = AMQP.Connection.open(username: username, password: password)
    children ++ [:poolboy.child_spec(:rabbitmq_pool, rabbitmq_pool_opts, [conn])]
  end
end
