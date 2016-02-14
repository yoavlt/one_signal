defmodule OneSignal.ParamTest do
  use ExUnit.Case
  import OneSignal.Param

  test "put message" do
    param = OneSignal.new
            |> put_message(:en, "Hello")
            |> put_message(:ja, "はろー")

    assert param.messages == %{:en => "Hello", :ja => "はろー"}
  end

  test "put message without specifying languages" do
    param = OneSignal.new |> put_message("Hello")
    assert param.messages == %{:en => "Hello"}
  end

  test "put heading" do
    param = OneSignal.new
            |> put_heading("Title")
    assert param.headings == %{:en => "Title"}

    param = OneSignal.new
            |> put_heading(:en, "Title")
            |> put_heading(:ja, "タイトル")
    assert param.headings == %{:en => "Title", :ja => "タイトル"}
  end

  test "put segment" do
    param = OneSignal.new
            |> put_segment("Free Players")
            |> put_segment("New Players")
    refute Enum.empty?(param.included_segments)
    assert Enum.all?(param.included_segments,
              &(&1 in ["Free Players", "New Players"]))
  end

  test "put segments" do
    segs = ["Free Players", "New Players"]
    param = put_segments(OneSignal.new, segs)
    refute Enum.empty?(param.included_segments)
    assert Enum.all?(param.included_segments, &(&1 in segs))
  end

  test "drop segment" do
    segs = ["Free Players", "New Payers"]
    param = OneSignal.new
            |> put_segments(segs)
            |> drop_segments(segs)
    assert Enum.empty?(param.included_segments)
  end

  test "exclude segment" do
    param = OneSignal.new
            |> exclude_segment("Free Players")
            |> exclude_segment("New Players")
    assert Enum.all?(param.excluded_segments,
              &(&1 in ["Free Players", "New Players"]))
  end

  test "exclude segments" do
    segs = ["Free Players", "New Players"]
    param =
      exclude_segments(OneSignal.new, segs)
    refute Enum.empty?(param.excluded_segments)
    assert Enum.all?(param.excluded_segments, &(&1 in segs))
  end

  test "build parameter" do
    param = OneSignal.new
            |> put_heading("Welcome!")
            |> put_message(:en, "Hello")
            |> put_message(:ja, "はろー")
            |> exclude_segment("Free Players")
            |> exclude_segment("New Players")
            |> build

    assert param["contents"]
    assert param["app_id"]
    assert param["headings"]
    assert param["excluded_segments"]
  end

  test "push notification" do
    notified = OneSignal.new
              |> put_heading("Welcome!")
              |> put_message(:en, "Hello")
              |> put_message(:ja, "はろー")
              |> put_segment("Free Players")
              |> put_segment("New Players")
              |> notify
    assert %OneSignal.Notification{} = notified
  end

  test "put player id" do
    param = put_player_id(OneSignal.new, "aiueo")
    refute Enum.empty?(param.include_player_ids)
  end

  test "exclude player id" do
    param = exclude_player_id(OneSignal.new, "aiueo")
    refute Enum.empty?(param.exclude_player_ids)
  end

end
