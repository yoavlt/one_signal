defmodule OneSignal.API do
  alias HTTPoison.Response
  alias OneSignal.{Error, Utils}

  def get!(url, query \\ []) do
    case get(url, query) do
      {:ok, value} -> value
      {:error, reason} -> raise Error, reason
    end
  end

  def get(url, query \\ []) do
    start()

    with url <- OneSignal.Utils.format_url(url, query),
         {:ok, response} <- get_request(url) do
      response |> handle_response()
    else
      {:error, error} -> {:error, error}
      error -> {:error, {:unknown, "An unknown error has occured", error}}
    end
  end

  defp get_request(url) do
    responses =
      if include_legacy_notifications(),
        do: [get_request(url, :current), get_request(url, :legacy)],
        else: [get_request(url, :current)]

    responses |> pick_response()
  end

  defp get_request(url, type) do
    with get_notification <- Utils.config()[:get_notification],
         {:ok, response} <- get_notification.(url, OneSignal.auth_header(type)) do
      {:ok, response}
    else
      {:error, error} -> {:error, error}
      error -> {:error, {:unknown, "An unknown error has occured", error}}
    end
  end

  def post!(url, body) do
    case post(url, body) do
      {:ok, value} -> value
      {:error, reason} -> raise Error, reason
    end
  end

  def post(url, body) do
    start()

    with {:ok, response} <- post_request(url, body) do
      response |> handle_response()
    else
      {:error, error} ->
        {:error, error}

      error ->
        {:error, {:unknown, "An unknown error has occured", error}}
    end
  end

  defp post_request(url, body) do
    responses =
      if include_legacy_notifications(),
        do: [post_request(url, body, :current), post_request(url, body, :legacy)],
        else: [post_request(url, body, :current)]

    responses |> pick_response()
  end

  defp post_request(url, body, type) do
    with body <- Map.put(body, :app_id, OneSignal.fetch_app_id(type)),
         {:ok, req_body} <- Poison.encode(body),
         post_notification <- Utils.config()[:post_notification],
         {:ok, req_header} <- OneSignal.auth_header(type),
         {:ok, response} <- post_notification.(url, req_body, req_header) do
      {:ok, response}
    else
      {:error, error} ->
        {:error, error}

      error ->
        {:error, {:unknown, "An unknown error has occured", error}}
    end
  end

  def delete!(url) do
    case delete(url) do
      {:ok, value} -> value
      {:error, reason} -> raise Error, reason
    end
  end

  def delete(url) do
    start()

    with {:ok, response} <- delete_request(url) do
      response |> handle_response()
    else
      {:error, error} -> {:error, error}
      error -> {:error, {:unknown, "An unknown error has occured", error}}
    end
  end

  defp delete_request(url) do
    responses =
      if include_legacy_notifications(),
        do: [delete_request(url, :current), delete_request(url, :legacy)],
        else: [delete_request(url, :current)]

    responses |> pick_response()
  end

  defp delete_request(url, type) do
    with delete_notification <- Utils.config()[:delete_notification],
         {:ok, response} <- delete_notification.(url, OneSignal.auth_header(type)) do
      {:ok, response}
    else
      {:error, error} -> {:error, error}
      error -> {:error, {:unknown, "An unknown error has occured", error}}
    end
  end

  defp handle_response(%Response{body: body, status_code: code})
       when code in 200..299 do
    with {:ok, result} <- Poison.decode(body) do
      {:ok, result}
    else
      {:error, :invalid} -> {:error, {:invalid, "Could not parse invalid body"}}
      {:error, error} -> {:error, error}
      error -> {:error, {:unknown, "An unknown error has occured", error}}
    end
  end

  defp handle_response(%Response{body: body, status_code: _code}) do
    with {:ok, result} <- Poison.decode(body) do
      {:error, {:httpoison, result}}
    else
      {:error, :invalid} -> {:error, {:invalid, "Could not parse invalid body"}}
      {:error, error} -> {:error, error}
      error -> {:error, {:unknown, "An unknown error has occured", error}}
    end
  end

  defp handle_response(error),
    do: {:error, {:unknown, "An unknown error has occured", error}}

  defp include_legacy_notifications() do
    if not is_nil(Utils.config()[:legacy_api_key]) and
         not is_nil(Utils.config()[:legacy_app_id]),
       do: true,
       else: false
  end

  defp pick_response(responses) do
    success =
      Enum.find(responses, fn
        {:ok, _} -> true
        _ -> false
      end)

    case success do
      # return first successful response, should fallback to :legacy
      {:ok, response} -> {:ok, response}
      # If both failed, return the :current error
      nil -> List.first(responses)
    end
  end

  defp start() do
    module = Utils.config()[:httpoison_start] || HTTPoison
    module.start()
  end
end
