import unittest
from end_screen_and_card_optimization import optimize_end_screen_and_cards

class TestEndScreenAndCardOptimization(unittest.TestCase):
    def test_optimize_end_screen_and_cards(self):
        video_id = 'test_video_id'
        optimized_end_screen, optimized_cards = optimize_end_screen_and_cards(video_id)
        self.assertIsNotNone(optimized_end_screen)
        self.assertIsNotNone(optimized_cards)