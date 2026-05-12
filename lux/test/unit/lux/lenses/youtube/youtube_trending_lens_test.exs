defmodule Lux.Lenses.YouTube.YouTubeTrendingLensTest do
  use UnitCase, async: true

  alias Lux.Lenses.YouTube.YouTubeTrendingLens

  describe "YouTubeTrendingLens" do
    test "defines expected structure" do
      view = YouTubeTrendingLens.view()
      assert view.name == "YouTube Trending Intelligence"
      assert view.method == :get
    end

    test "after_focus transforms raw response correctly" do
      mock_response = %{
        "items" => [
          %{
            "id" => "vid123",
            "snippet" => %{
              "title" => "Test Video",
              "description" => "Test Description",
              "tags" => ["tag1", "tag2"]
            },
            "statistics" => %{
              "viewCount" => "1000",
              "likeCount" => "100",
              "commentCount" => "10"
            },
            "contentDetails" => %{
              "duration" => "PT5M"
            }
          }
        ]
      }

      {:ok, %{"trending_videos" => videos}} = YouTubeTrendingLens.after_focus(mock_response)
      assert length(videos) == 1
      assert hd(videos)["title"] == "Test Video"
      assert hd(videos)["viewCount"] == "1000"
    end
  end
end
