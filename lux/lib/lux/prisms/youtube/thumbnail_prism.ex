defmodule Lux.Prisms.YouTube.ThumbnailPrism do
  @moduledoc """
  A prism that generates a physical YouTube thumbnail image using a Python script.
  """
  use Lux.Prism,
    name: "YouTube Thumbnail Generator",
    description: "Generates a YouTube thumbnail image with a title and background using Python/Pillow",
    input_schema: %{
      type: :object,
      properties: %{
        title: %{type: :string},
        background_color: %{type: :string, default: "#333333"},
        output_dir: %{type: :string}
      },
      required: ["title"]
    },
    output_schema: %{
      type: :object,
      properties: %{
        thumbnail_path: %{type: :string}
      },
      required: ["thumbnail_path"]
    }

  def handler(input, _context) do
    # We use Lux.Python to call the thumbnail_generator_prism.py script.
    # The script is located in priv/python/
    
    code = """
    from thumbnail_generator_prism import ThumbnailGeneratorPrism
    prism = ThumbnailGeneratorPrism.new()
    prism.handler(input_data, {})
    """
    
    case Lux.Python.eval(code, variables: %{input_data: input}) do
      {:ok, result} -> {:ok, result}
      {:error, reason} -> {:error, "Python Thumbnail Generation Failed: #{inspect(reason)}"}
    end
  end
end
