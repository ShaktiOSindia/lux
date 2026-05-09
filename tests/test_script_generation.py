import unittest
from script_generation import generate_script

class TestScriptGeneration(unittest.TestCase):
    def test_script_generation(self):
        video_title = 'Test Video'
        video_description = 'This is a test video'
        script = generate_script(video_title, video_description)
        self.assertIsNotNone(script)