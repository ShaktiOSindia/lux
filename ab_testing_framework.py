import random

def run_ab_test(video_id, test_group):
    # Get the video's metrics
    metrics = youtube_api.get_metrics(video_id)
    # Run the A/B test
    if test_group == 'control':
        return metrics
    elif test_group == 'treatment':
        # Apply the treatment
        metrics['views'] += 10
        return metrics