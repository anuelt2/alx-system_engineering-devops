#!/usr/bin/python3
"""
Script that uses a REST API with given emplyee ID to return information
about employee TODO list progress
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

    employee_name = user["name"]
    total_number_of_tasks = len(todos)
    number_of_done_tasks = 0

    for task in todos:
        if task["completed"]:
            number_of_done_tasks += 1

    print(f"Employee {employee_name} is done with tasks"
          f"({number_of_done_tasks}/{total_number_of_tasks}):")

    for task in todos:
        if task["completed"]:
            print("\t", task["title"])
