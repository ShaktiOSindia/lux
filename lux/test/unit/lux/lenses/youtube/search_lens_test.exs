defmodule Lux.Lenses.YouTube.SearchLensTest do
  use UnitCase, async: true

  alias Lux.Lenses.YouTube.SearchLens

  describe "after_focus/1" do
    test "successfully transforms search results" do
      response = %{
        "items" => [
          %{
            "id" => %{"videoId" => "123"},
            "snippet" => %{
              "title" => "Test Video",
              "description" => "Test Desc",
              "channelTitle" => "Test Channel",
              "publishedAt" => "2026-05-11T12:00:00Z"
            }
          }
        ]
      }

      assert {:ok, [result]} = SearchLens.after_focus(response)
      assert result.id == "123"
      assert result.title == "Test Video"
    end

    test "handles API errors" do
      response = %{"error" => %{"message" => "API Key Invalid"}}
      assert {:error, "API Key Invalid"} = SearchLens.after_focus(response)
    end
  end
end
