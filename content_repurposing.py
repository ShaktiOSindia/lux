import youtube_api

def repurpose_content(video_id):
    # Get the video's content
    content = youtube_api.get_content(video_id)
    # Repurpose the content
    repurposed_content = content
    # Add a new format to the content
    repurposed_content['format'] = 'podcast'
    return repurposed_content