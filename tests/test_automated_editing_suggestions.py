import unittest
from automated_editing_suggestions import suggest_edits

class TestAutomatedEditingSuggestions(unittest.TestCase):
    def test_suggest_edits(self):
        video_file = 'test_video.mp4'
        edits = suggest_edits(video_file)
        self.assertIsNotNone(edits)