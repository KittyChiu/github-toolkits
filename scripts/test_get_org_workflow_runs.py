"""
This file contains unit tests for the `get_org_workflow_runs.py` script.

Usage:
    python -m unittest test_get_org_workflow_runs.TestGetOrgWorkflowRuns.test_get_org_workflow_runs

Requirements:
    - Python 3.x
    - `jq` command-line tool
    - `get_org_workflow_runs.py` script to test
    - logged in to GitHub CLI
    - `pytest` library

Output:
    - Test results for the `get_org_workflow_runs.py` script

Example:
    python -m unittest test_get_org_workflow_runs.TestGetOrgWorkflowRuns.test_get_org_workflow_runs

This file contains unit tests for the `get_org_workflow_runs.py` script. The tests use the `pytest` library to run the tests and generate the test results.

The `get_org_workflow_runs.py` script retrieves all workflow runs for all repositories in the organization within the specified date range. The unit tests in this file test the functionality of the script by checking that the output of the script matches the expected output for various input parameters.

Note: You must set the `GITHUB_TOKEN` environment variable to your GitHub API token with `repo` scope before running the tests.
"""

import unittest
import subprocess
import json
import os

class TestGetWorkflowRuns(unittest.TestCase):
    def setUp(self):
        self.repo_owner = "myorg"
        self.start_date = "2023-07-28"
        self.end_date = "2023-08-03"
        self.invalid_start_date = "abc"
        self.invalid_end_date = "xyz"

    def test_get_workflow_runs_with_valid_dates(self):
        # Run the script to retrieve workflow runs with valid dates
        subprocess.run(["python", "get_org_workflow_runs.py", self.repo_owner, self.start_date, self.end_date])

        # Load the workflow runs from file
        with open("runs.json", "r") as f:
            workflow_runs = json.load(f)

        # Check that the workflow runs are not empty
        self.assertGreater(len(workflow_runs), 0)

        # Check that each workflow run has the expected fields
        for run in workflow_runs:
            self.assertIn("conclusion", run)
            self.assertIn("created_at", run)
            self.assertIn("display_title", run)
            self.assertIn("event", run)
            self.assertIn("head_branch", run)
            self.assertIn("name", run)
            self.assertIn("run_number", run)
            self.assertIn("run_started_at", run)
            self.assertIn("run_attempt", run)
            self.assertIn("status", run)
            self.assertIn("updated_at", run)
            self.assertIn("url", run)
            self.assertIn("duration", run)
            self.assertIn("repo_name", run)
            self.assertIn("workflow_id", run)

        # Print the workflow runs
        with open("runs.json", "r") as f:
            raw_json = f.read()
            print("Number of characters in runs.json:", len(raw_json))

        # Clean up the temporary file
        # os.remove("runs.json")

if __name__ == '__main__':
    unittest.main()