defmodule OneSignal.API do
  alias HTTPoison.Response
  alias OneSignal.Error

  def get!(url, query \\ []) do
    case get(url, query) do
      {:ok, value} -> value
      {:error, reason} -> raise Error, reason
    end
  end

  def get(url, query \\ []) do
    HTTPoison.start()

    with url <- OneSignal.Utils.format_url(url, query),
         {:ok, response} <- HTTPoison.get(url, OneSignal.auth_header()) do
      response |> handle_response()
    else
      {:error, error} -> {:error, error}
      _ -> {:error, {:unknown, "An unknown error has occured"}}
    end
  end

  def post!(url, body) do
    case post(url, body) do
      {:ok, value} -> value
      {:error, reason} -> raise Error, reason
    end
  end

  def post(url, body) do
    HTTPoison.start()

    with {:ok, req_body} <- Poison.encode(body),
         {:ok, response} <- HTTPoison.post(url, req_body, OneSignal.auth_header()) do
      response |> handle_response()
    else
      {:error, error} -> {:error, error}
      _ -> {:error, {:unknown, "An unknown error has occured"}}
    end
  end

  def delete!(url) do
    case delete(url) do
      {:ok, value} -> value
      {:error, reason} -> raise Error, reason
    end
  end

  def delete(url) do
    HTTPoison.start()

    with {:ok, response} <- HTTPoison.delete(url, OneSignal.auth_header()) do
      response |> handle_response()
    else
      {:error, error} -> {:error, error}
      _ -> {:error, {:unknown, "An unknown error has occured"}}
    end
  end

  defp handle_response(%Response{body: body, status_code: code})
       when code in 200..299 do
    with {:ok, result} <- Poison.decode(body) do
      {:ok, result}
    else
      {:error, :invalid} -> {:error, {:invalid, "Could not parse invalid body"}}
      {:error, error} -> {:error, error}
      _ -> {:error, {:unknown, "An unknown error has occured"}}
    end
  end

  defp handle_response(%Response{body: body, status_code: _}) do
    with {:ok, result} <- Poison.decode(body) do
      {:error, {:httpoison, result}}
    else
      {:error, :invalid} -> {:error, {:invalid, "Could not parse invalid body"}}
      {:error, error} -> {:error, error}
      _ -> {:error, {:unknown, "An unknown error has occured"}}
    end
  end

  defp handle_response(_),
    do: {:error, {:unknown, "An unknown error has occured"}}
end
