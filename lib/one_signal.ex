defmodule OneSignal do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = []

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: OneSignal.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def endpoint, do: "https://onesignal.com/api/v1"

  def new do
    %OneSignal.Param{}
  end

  def auth_header do
    %{"Authorization" => "Basic " <> fetch_api_key(), "Content-type" => "application/json"}
  end

  defp config do
    Application.get_env(:one_signal, OneSignal, %{})
  end

  defp fetch_api_key do
    config()[:api_key] || System.get_env("ONE_SIGNAL_API_KEY")
  end

  def fetch_app_id do
    config()[:app_id] || System.get_env("ONE_SIGNAL_APP_ID")
  end

  @spec json_library :: any
  def json_library do
    Application.get_env(:one_signal, :json_library, Poison)
  end
end
