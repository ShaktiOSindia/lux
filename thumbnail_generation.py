import cv2
import numpy as np

def generate_thumbnail(video_file):
    # Load the video file
    cap = cv2.VideoCapture(video_file)
    # Get the first frame
    ret, frame = cap.read()
    # Generate the thumbnail
    thumbnail = cv2.resize(frame, (1280, 720))
    return thumbnail