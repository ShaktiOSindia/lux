import unittest
from thumbnail_generation import generate_thumbnail

class TestThumbnailGeneration(unittest.TestCase):
    def test_thumbnail_generation(self):
        video_file = 'test_video.mp4'
        thumbnail = generate_thumbnail(video_file)
        self.assertIsNotNone(thumbnail)