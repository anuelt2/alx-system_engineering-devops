#!/usr/bin/python3
"""Module for count_words function"""
import requests


def count_words(subreddit, word_list, hot_list=[], count=0, after=None):
    """
    Recursive function that queries the Reddit API, parses the title
    of all hot articles, and prints a sorted count of given keywords.
    """
    if count == 0:
        url = f"https://www.reddit.com/r/{subreddit}/hot.json"
    else:
        url = f"https://www.reddit.com/r/{subreddit}/hot.json?after={after}"
    headers = {"User-Agent": "Mozilla/5.0"}
    response = requests.get(url, headers=headers, allow_redirects=False)

    if response.status_code != 200:
        return

    data = response.json()
    for post in data["data"]["children"]:
        hot_list.append(post["data"]["title"])

    count += 1
    after = data["data"]["after"]

    if after is None:
        return count_help(word_list, hot_list)
    else:
        return count_words(subreddit, word_list,
                           hot_list=hot_list, count=count, after=after)


def count_help(word_list, hot_list):
    """Prints a sorted count of given keywords of a given list"""
    word_list = [word.lower() for word in word_list]
    count_dict = {}

    for word in word_list:
        word_count = 0
        for title in hot_list:
            if word in title.lower():
                word_count += 1
        if word_count == 0:
            continue
        if word in count_dict:
            word_count = count_dict[word] + word_count
        count_dict[word] = word_count

    if not count_dict:
        return
    sorted_count_dict = dict(sorted(count_dict.items(),
                                    key=lambda item: (-item[1], item[0])))

    for key, value in sorted_count_dict.items():
        print(f"{key}: {value}")
