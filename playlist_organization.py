import youtube_api

def organize_playlists(channel_id):
    # Get the channel's playlists
    playlists = youtube_api.get_playlists(channel_id)
    # Organize the playlists
    organized_playlists = []
    for playlist in playlists:
        organized_playlists.append(playlist['title'])
    return organized_playlists