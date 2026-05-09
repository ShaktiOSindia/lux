import youtube_api

def repurpose_content(video_id):
    # Get the video's content
    content = youtube_api.get_content(video_id)
    # Repurpose the content
    repurposed_content = content
    # Convert the video to a blog post
    repurposed_content['blog_post'] = 'This is a blog post based on the video'
    return repurposed_content