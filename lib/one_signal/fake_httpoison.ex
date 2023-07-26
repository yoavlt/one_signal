defmodule OneSignal.FakeHTTPoison do
  def post(_, _, _) do
    {:ok,
     %OneSignal.Notification{
       id: "27d90540-e270-41a7-b9d2-ef3c26c1613d",
       recipients: 1
     }}
  end

  def get(_, _ \\ []) do
    {:ok,
     %OneSignal.Notification{
       id: "27d90540-e270-41a7-b9d2-ef3c26c1613d",
       recipients: 1
     }}
  end

  def delete(_, _) do
    {:ok,
     %OneSignal.Notification{
       id: "27d90540-e270-41a7-b9d2-ef3c26c1613d",
       recipients: 1
     }}
  end
end
