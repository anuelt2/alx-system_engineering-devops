#!/usr/bin/python3
"""
Script that uses a REST API to return information about employees'
TODO list and exports data in JSON format
"""
import json
import requests


if __name__ == "__main__":
    users_url = "https://jsonplaceholder.typicode.com/users/"
    response = requests.get(users_url)
    users = response.json()

    todo_url = "https://jsonplaceholder.typicode.com/todos/"
    response = requests.get(todo_url)
    todos = response.json()

    filename = "todo_all_employees.json"

    data = {}

    for user in users:
        user_tasks = []
        for task in todos:
            if task["userId"] == user["id"]:
                task_dict = {
                        "username": user["username"],
                        "task": task["title"],
                        "completed": task["completed"]
                        }
                user_tasks.append(task_dict)
        data[user["id"]] = user_tasks

    with open(filename, "w") as file:
        json.dump(data, file)
