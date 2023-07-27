import Config

config :one_signal, OneSignal,
  get_notification: &OneSignal.FakeHTTPoison.get/2,
  post_notification: &OneSignal.FakeHTTPoison.post/3,
  delete_notification: &OneSignal.FakeHTTPoison.delete/2

if File.exists?("config/test.secret.exs") do
  import_config "test.secret.exs"
end
