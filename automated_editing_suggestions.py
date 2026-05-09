import moviepy
from moviepy.editor import VideoFileClip

def suggest_edits(video_file):
    # Load the video file
    clip = VideoFileClip(video_file)
    # Analyze the video
    analysis = clip.analyze()
    # Suggest edits based on the analysis
    edits = []
    if analysis['duration'] > 10:
        edits.append('Trim the video to 10 minutes or less')
    if analysis['resolution'] < 1080:
        edits.append('Increase the resolution to 1080p or higher')
    return edits