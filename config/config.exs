# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
#     config :one_signal, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:one_signal, :key)
#
# Or configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#

config :one_signal, OneSignal,
  api_key: "your api key",
  app_id: "your app id",
  legacy_api_key: "your legacy api key",
  legacy_app_id: "your legacy app id",
  sms_from: "your registered Twilio phone number in E.164 format",
  get_notification: &HTTPoison.get/2,
  post_notification: &HTTPoison.post/3,
  delete_notification: &HTTPoison.delete/2

import_config("#{Mix.env()}.exs")
