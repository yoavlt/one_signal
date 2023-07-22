defmodule OneSignal.Utils do
  @doc """
  Encode request body
  """

  def format_url(url, query) do
    query =
      Enum.map_join(query, "&", fn x ->
        pair(x)
      end)

    url =
      unless String.length(query) == 0 do
        "#{url}?#{query}"
      end

    url
  end

  defp pair({key, value}) do
    if Enumerable.impl_for(value) do
      pair(to_string(key), [], value)
    else
      param_name = key |> to_string |> URI.encode()
      param_value = value |> to_string |> URI.encode()

      "#{param_name}=#{param_value}"
    end
  end

  defp pair(root, parents, values) do
    Enum.map_join(values, "&", fn {key, value} ->
      if Enumerable.impl_for(value) do
        pair(root, parents ++ [key], value)
      else
        build_key(root, parents ++ [key]) <> to_string(value)
      end
    end)
  end

  defp build_key(root, parents) do
    path =
      Enum.map_join(parents, "", fn x ->
        param = x |> to_string |> URI.encode()
        "[#{param}]"
      end)

    "#{root}#{path}="
  end
end
