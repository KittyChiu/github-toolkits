# Workflow for GitHub.com

These are proof of concepts for automation using Actions. They are not production ready. You can use them as a starting point to build your own.

GitHub [Actions documentation](https://docs.github.com/en/actions) has a rich set of articles from Getting Started to referenced librarys for Actions context.

## `evaluate-workflow-usage.yml`

This workflow is to generate a summary of workflow runs within the hosted repository with the given date period. The summary is represented in both Value Stream view and Table view.

#### Sample report
![screenshot](assets/evaluate-workflow-usage-screenshot.png)

#### How to use
- Create a `yml` workflow under `.github/workflows/` folder
- Add `get_workflow_runs.py` and `evaluate_workflow_runs.py` to `.github/scripts/` folder
- Set the desired `on` trigger

#### Expected outcomes
- An Issue will be created with the formatted data


#### Variations
- Workflow names can also be manually defined and ordered in the workflow-names.txt file.
- `START_DATE` and `END_DATE` in `step: Set dates` - They are set to one month apart. This can be modified to the desired duration.
- Templates in `step: Generate Mermaid diagram in markdown` and `step: Generate Mermaid diagram in markdown` need to be updated.


## `evaluate-org-workflow-usage.yml`

This workflow is to generate a summary of workflow runs within the hosted repository with the given date period. The summary is represented in both Value Stream view and Table view.

#### Sample report
![screenshot](assets/evaluate-org-workflow-usage-screenshot.png)

#### How to use
- Create a `yml` workflow under `.github/workflows/` folder
- Add `get_org_workflow_runs.py` and `evaluate_org_workflow_runs.py` to `.github/scripts/` folder
- Set the desired `on` trigger

#### Expected outcomes
- An Issue will be created with the formatted data


#### Variations
- `START_DATE` and `END_DATE` in `step: Set dates` - They are set to one month apart. This can be modified to the desired duration.
- Template in `step: Generate table diagram in markdown` can be customised with styling.


## `create-pr-on-new-issue.yml`

This workflow attempts to orchestrate the beginning of [GitHub Flow](https://docs.github.com/en/get-started/quickstart/github-flow).


#### Flowchart
```mermaid

flowchart LR
    A[Issue Opened] --> B[Create branch]
    B --> C[Convert Issue to Pull Request]

```

#### How to use
- Create a `yml` workflow under `.github/workflows/` folder

#### Expected outcomes
- When a new issue is created, a new branch and a pull request are automatically created.