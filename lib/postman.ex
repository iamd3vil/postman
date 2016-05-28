defmodule Postman do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    purpose = Application.get_env(:postman, :purpose)
    interaction = Application.get_env(:postman, :interaction)
    # Adding children dynamically according to the config
    children = []
    |> get_children(purpose, interaction)

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

    {:ok, conn} = AMQP.Connection.open("amqp://guest:guest@localhost")
    children ++ [worker(Postman.RabbitmqWorker, [conn])]
  end
end
