import youtube_api

def manage_metadata(video_id):
    # Get the video's metadata
    metadata = youtube_api.get_metadata(video_id)
    # Manage the metadata
    managed_metadata = metadata
    # Add a new tag to the metadata
    managed_metadata['tags'].append('new_tag')
    return managed_metadata