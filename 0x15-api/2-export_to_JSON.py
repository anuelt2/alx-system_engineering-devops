#!/usr/bin/python3
"""
Script that uses a REST API with given emplyee ID to return information
about employee TODO list and exports data in JSON format
"""
import json
import requests
from sys import argv


if __name__ == "__main__":
    employee_id = argv[1]

    user_url = f"https://jsonplaceholder.typicode.com/users/{employee_id}"
    response = requests.get(user_url)
    user = response.json()

    todo_url = (
            f"https://jsonplaceholder.typicode.com/todos?userId={employee_id}"
            )
    response = requests.get(todo_url)
    todos = response.json()

    user_id = user["id"]
    username = user["username"]
    filename = f"{user_id}.json"

    tasks = [
            {
                "task": task["title"],
                "completed": task["completed"],
                "username": username
                }
            for task in todos
            ]

    data = {user_id: tasks}

    with open(filename, "w") as file:
        json.dump(data, file)
