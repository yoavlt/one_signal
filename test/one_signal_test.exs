defmodule OneSignalTest do
  use ExUnit.Case
  doctest OneSignal

  test "create one signal structure" do
    assert %OneSignal.Param{} = OneSignal.new()
  end
end
