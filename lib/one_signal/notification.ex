defmodule OneSignal.Notification do
  defstruct id: nil, recipients: 0



  @doc """
  Send push notification
  iex> OneSignal.Notification.send(%{"en" => "Hello!", "ja" => "はろー"}, %{"included_segments" => ["All"], "isAndroid" => true})
  """
  def send(contents, opts) do
    param = %{"contents" => contents, "app_id" => OneSignal.fetch_app_id}
    body = Map.merge(param, opts)
    url  = post_notification_url()
    case OneSignal.API.post(url, body) do
      {:ok, response} ->
        response = Enum.map(response, &to_key_atom/1)
        struct(__MODULE__, response)
      err -> err
    end
  end

  def send(body) do
    case OneSignal.API.post(post_notification_url(), body) do
      {:ok, response} ->
        response = Enum.map(response, &to_key_atom/1)
        struct(__MODULE__, response)
      err -> err
    end
  end

  def send_background(body) do
    body = body
    |> Map.put("content_available", true) #needed to setup backgorund
    |> Map.delete("contents") # need to remove contents for it to work

    case OneSignal.API.post(post_notification_url(), body) do
      {:ok, response} ->
        response = Enum.map(response, &to_key_atom/1)
        struct(__MODULE__, response)
      err -> err
    end
  end

  def post_notification_url() do
    OneSignal.endpoint <> "/notifications"
  end

  def to_key_atom({k, v}) do
    {String.to_atom(k), v}
  end
end
