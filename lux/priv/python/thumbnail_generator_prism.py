from lux.prism import Prism
from PIL import Image, ImageDraw, ImageFont
import os
import uuid

class ThumbnailGeneratorPrism(Prism):
    id = 'e9f89999-5555-4444-3333-222222222222'
    name = 'Thumbnail Generator Prism'
    description = 'Generates a YouTube thumbnail image with a title and background'
    input_schema = {
        'type': 'object',
        'properties': {
            'title': {
                'type': 'string',
                'description': 'The title text to display on the thumbnail'
            },
            'background_color': {
                'type': 'string',
                'description': 'The background color in hex (e.g. #FF0000)'
            },
            'output_dir': {
                'type': 'string',
                'description': 'Directory to save the generated thumbnail'
            }
        },
        'required': ['title']
    }
    output_schema = {
        'type': 'object',
        'properties': {
            'thumbnail_path': {
                'type': 'string',
                'description': 'Path to the generated thumbnail image'
            }
        }
    }

    def handler(self, input_data, context):
        title = input_data.get('title', 'Awesome Video')
        bg_color = input_data.get('background_color', '#333333')
        output_dir = input_data.get('output_dir', os.getcwd())
        
        # Create image
        width, height = 1280, 720
        image = Image.new('RGB', (width, height), color=bg_color)
        draw = ImageDraw.Draw(image)
        
        try:
            # Try some common windows fonts
            font = ImageFont.truetype("arial.ttf", 80)
        except IOError:
            font = ImageFont.load_default()
            
        # Draw title text centered roughly
        text_bbox = draw.textbbox((0, 0), title, font=font)
        text_w = text_bbox[2] - text_bbox[0]
        text_h = text_bbox[3] - text_bbox[1]
        
        text_x = (width - text_w) / 2
        text_y = (height - text_h) / 2
        
        draw.text((text_x, text_y), title, fill="white", font=font)
        
        # Draw some graphics
        draw.rectangle([(100, 100), (300, 300)], fill="#FF5555", outline="white", width=5)
        draw.ellipse([(980, 420), (1180, 620)], fill="#5555FF", outline="white", width=5)
        
        # Ensure output dir exists
        os.makedirs(output_dir, exist_ok=True)
        
        filename = f"thumbnail_{uuid.uuid4().hex[:8]}.png"
        filepath = os.path.join(output_dir, filename)
        
        # Use absolute path for safety
        abs_filepath = os.path.abspath(filepath)
        image.save(abs_filepath)
        
        return {
            'thumbnail_path': abs_filepath
        }

    @staticmethod
    def new():
        return ThumbnailGeneratorPrism()
