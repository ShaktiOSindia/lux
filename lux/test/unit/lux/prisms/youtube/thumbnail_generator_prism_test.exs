defmodule Lux.Prisms.Youtube.ThumbnailGeneratorPrismTest do
  use ExUnit.Case

  alias Lux.Prism

  test "runs the python thumbnail generator prism" do
    prism_path = Path.join([__DIR__, "..", "..", "..", "priv", "python", "thumbnail_generator_prism.py"])
    
    input = %{
      "title" => "Test Video Title",
      "background_color" => "#123456",
      "output_dir" => System.tmp_dir!()
    }

    assert {:ok, result} = Prism.run(prism_path, input, nil)
    
    assert Map.has_key?(result, "thumbnail_path")
    assert File.exists?(result["thumbnail_path"])
  end
end
