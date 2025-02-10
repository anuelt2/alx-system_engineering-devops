#!/usr/bin/python3
"""
Script that uses a REST API with given emplyee ID to return information
about employee TODO list and exports data in CSV format
"""
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
    filename = f"{user_id}.csv"

    with open(filename, "w") as file:
        data = f'"{user_id}","{username}",'
        for task in todos:
            data = ('"{}","{}","{}","{}"'
                    .format(
                        user_id,
                        username,
                        task["completed"],
                        task["title"]
                        ))
            file.write(data + "\n")
