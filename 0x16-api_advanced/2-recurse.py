#!/usr/bin/python3
"""Module for recurse function"""
import requests


def recurse(subreddit, hot_list=[], count=0, after=None):
    """
    Recursive function that queries the Reddit API and returns a list
    containing titles of all hot articles for a given subreddit.
    """
    if count == 0:
        url = f"https://www.reddit.com/r/{subreddit}/hot.json"
    else:
        url = f"https://www.reddit.com/r/{subreddit}/hot.json?after={after}"
    headers = {"User-Agent": "Mozilla/5.0"}
    response = requests.get(url, headers=headers, allow_redirects=False)

    if response.status_code != 200:
        return None

    data = response.json()
    for post in data["data"]["children"]:
        hot_list.append(post["data"]["title"])

    count += 1
    after = data["data"]["after"]

    if after is None:
        return hot_list
    else:
        return recurse(subreddit, hot_list=hot_list, count=count, after=after)
