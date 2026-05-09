import unittest
from content_repurposing import repurpose_content

class TestContentRepurposing(unittest.TestCase):
    def test_repurpose_content(self):
        video_id = 'test_video_id'
        repurposed_content = repurpose_content(video_id)
        self.assertIsNotNone(repurposed_content)