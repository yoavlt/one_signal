defmodule OneSignal.Error do
  defexception [:reason]

  def exception(reason),
    do: %__MODULE__{reason: reason}

  def message(%__MODULE__{reason: reason}),
    do: format_error(reason)

  defp format_error({:httpoison, value}),
    do: "HTTPoison error: #{inspect(value)}"

  defp format_error({:invalid, value}), do: "Invalid body in request: #{inspect(value)}"

  defp format_error(%{reason: value}),
    do: "Invalid request: #{inspect(value)}"

  defp format_error({:unknown, value}), do: value

  defp format_error({:not_implemented, value}), do: value
end
