import Config

config :one_signal, OneSignal, notification: OneSignal.Test.FakeNotification

if File.exists?("config/test.secret.exs") do
  import_config "test.secret.exs"
end
