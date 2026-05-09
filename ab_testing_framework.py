import random

def ab_test(video_id):
    # Get the video's metadata
    metadata = youtube_api.get_metadata(video_id)
    # Create two versions of the video
    version_a = metadata
    version_b = metadata
    # Change the thumbnail of version B
    version_b['thumbnail'] = 'new_thumbnail.jpg'
    # Randomly select a version to show to the user
    version_to_show = random.choice([version_a, version_b])
    return version_to_show