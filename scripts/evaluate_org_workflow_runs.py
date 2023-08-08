"""
This script evaluates the stats for each workflow in the `runs.json` file and outputs the results to a CSV file.

Usage:
    python evaluate_org_workflow_runs.py

Requirements:
    - Python 3.x
    - `runs.json` file containing the workflow runs to evaluate

Output:
    - `org-workflow-stats.csv` file containing the stats for each workflow in the organization

Example:
    python evaluate_org_workflow_runs.py

This script reads the `runs.json` file, which should contain the workflow runs for all repositories in the organization. It then calculates the stats for each workflow, including the total number of runs, the average duration, and the success rate. The script outputs the results to a CSV file named `org-workflow-stats.csv`.

Note: The `runs.json` file should be generated using the `get_org_workflow_runs.py` script.
"""

import json
import os

# Delete existing org-workflow-stats.csv file if it exists
if os.path.exists('org-workflow-stats.csv'):
    os.remove('org-workflow-stats.csv')

# Load the runs from the runs.json file
with open('runs.json', 'r') as f:
    runs = json.load(f)

# Get a list of unique workflow_id values
workflow_ids = list(set(run['workflow_id'] for run in runs))

# Evaluate the stats for each workflow
for id in workflow_ids:
    print(f'Evaluating: {id}')

    # Filter the runs by workflow name
    runs_filtered = [run for run in runs if run['workflow_id'] == id]

    # Get repo name
    repo_name = runs_filtered[0]['repo_name']

    # Get workflow name
    workflow_name = runs_filtered[0]['name']

    # Evaluate the total number of runs
    total_runs = len(runs_filtered)
    # print(f'...Total runs: {total_runs}')

    # Evaluate the average duration
    if total_runs > 0:
        raw_average_duration = sum(run['duration'] for run in runs_filtered) / total_runs
        average_duration = f'{raw_average_duration:.2f}s'
    else:
        average_duration = '0.00s'
    # print(f'...Average duration: {average_duration}')

    # Evaluate the number of successful or skipped runs
    total_success = len([run for run in runs_filtered if run['conclusion'] in ['success', 'skipped']])
    # print(f'...Total success or skipped runs: {total_success}')

    # Evaluate the percentage of successful or skipped runs
    if total_runs > 0:
        percentage_success = f'{total_success / total_runs * 100:.1f}%'
    else:
        percentage_success = '0.0%'
    # print(f'...Percentage success or skipped runs: {percentage_success}')

    # Output the results to a CSV file
    with open('org-workflow-stats.csv', 'a') as f:
        f.write(f'{repo_name},{workflow_name},{average_duration},{percentage_success},{total_runs}\n')
