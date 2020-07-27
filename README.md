# OneSignal

Elixir wrapper of [OneSignal](https://onesignal.com)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add one_signal to your list of dependencies in `mix.exs`:

```elixir
  def deps do
    [{:one_signal, "~> 0.0.6"}]
  end
```

  2. Ensure one_signal is started before your application:

```elixir
  def application do
    [applications: [:one_signal]]
  end
```

  3. Puts config your `config.exs`

```elixir
config :one_signal, OneSignal,
  api_key: "your api key",
  app_id: "your app id",
```


## Composable design, Data structure oriented

```elixir
  import OneSignal.Param
  OneSignal.new
  |> put_heading("Welcome!")
  |> put_message(:en, "Hello")
  |> put_message(:ja, "はろー")
  |> put_segment("Free Players")
  |> put_segment("New Players")
  |> notify
```


#Backgorund notifications

you can also add background notifications. Useful for wen you want to trigger background tasks in your apps that are not currently in the foreground

```elixir
  import OneSignal.Param
  OneSignal.new
  |> put_segment("Free Players")
  |> put_segment("New Players")
  |> put_data("payload", %{ hash: "tag"})
  |> background_notify


```
