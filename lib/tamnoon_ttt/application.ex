defmodule TamnoonTtt.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Tamnoon,
       [
         [
           router: TamnoonTtt.Router,
           methods_modules: [
             TamnoonTtt.Methods.StartPageMethods,
             TamnoonTtt.Methods.QueueMethods,
             TamnoonTtt.Methods.GameMethods
           ],
           initial_state: %{
             name: ""
           }
         ]
       ]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TamnoonTtt.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
