#!/usr/bin/python3
"""Module for number_of_subscribers function"""
import requests


def number_of_subscribers(subreddit):
    """
    Function that queries a Reddit API and returns the number of
    subscribers for a given subreddit
    """
    url = f"https://www.reddit.com/r/{subreddit}/about.json"
    headers = {"User-Agent": "Mozilla/5.0"}
    response = requests.get(url, headers=headers, allow_redirects=False)

    if response.status_code != 200:
        return 0
    else:
        data = response.json()
        subscriber_count = data["data"]["subscribers"]
        return subscriber_count
