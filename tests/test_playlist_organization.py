import unittest
from playlist_organization import organize_playlists

class TestPlaylistOrganization(unittest.TestCase):
    def test_organize_playlists(self):
        channel_id = 'test_channel_id'
        organized_playlists = organize_playlists(channel_id)
        self.assertIsNotNone(organized_playlists)