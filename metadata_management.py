import youtube_api

def manage_metadata(video_id):
    # Get the video's metadata
    metadata = youtube_api.get_metadata(video_id)
    # Update the metadata
    metadata['title'] = 'New title'
    metadata['description'] = 'New description'
    return metadata