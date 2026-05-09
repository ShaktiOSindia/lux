import unittest
from ab_testing_framework import run_ab_test

class TestABTestingFramework(unittest.TestCase):
    def test_run_ab_test(self):
        video_id = 'test_video_id'
        test_group = 'control'
        metrics = run_ab_test(video_id, test_group)
        self.assertIsNotNone(metrics)