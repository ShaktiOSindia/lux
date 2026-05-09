import unittest

def test_content(video_id):
    # Get the video's content
    content = youtube_api.get_content(video_id)
    # Test the content
    class TestContent(unittest.TestCase):
        def test_title(self):
            self.assertEqual(content['title'], 'Expected title')
        def test_description(self):
            self.assertEqual(content['description'], 'Expected description')
    return TestContent