import Config

if File.exists?("config/dev.secret.exs") do
  import_config "dev.secret.exs"
end
