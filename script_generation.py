import nltk
from nltk.tokenize import word_tokenize

def generate_script(video_title, video_description):
    # Tokenize the video title and description
    title_tokens = word_tokenize(video_title)
    description_tokens = word_tokenize(video_description)
    # Generate the script
    script = """
    Intro:
    Welcome to our channel, where we talk about {}
    ".format(video_title)
    # Add the description to the script
    script += "Today, we're going to discuss {}
    ".format(video_description)
    # Add the outro to the script
    script += "Thanks for watching, don't forget to like and subscribe!"
    return script