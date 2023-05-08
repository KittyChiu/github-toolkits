#!/bin/bash
# Get a list of workflow runs by organization
#
# Usage: ./get-workflow-runs-by-org.sh <org_name> <start_date YYYY-MM-DD> <end_dat YYYY-MM-DD>

if [ $# -lt "3" ]; then
    echo "Usage: $0 <org_name> <start_date YYYY-MM-DD> <end_dat YYYY-MM-DD>" 
    exit 1
fi

org=$1
start_date=$2
end_date=$3

repos=$(gh repo list $org | awk '{print $1}')

for a_repo in $repos
do
    echo "Getting workflow runs for $a_repo"
    # split $a_repo into owner and repo
    owner=$(echo $a_repo | cut -d'/' -f1)
    reponame=$(echo $a_repo | cut -d'/' -f2)

    # Get the workflow runs for the repo
    runs=$(gh run list --repo $a_repo --created $start_date..$end_date --json 'conclusion,createdAt,displayTitle,event,headBranch,name,number,startedAt,status,updatedAt,url,workflowName')

    # Add the owner and reponame to the output
    echo $runs | jq --arg org $owner --arg repo $reponame '[.[] | .org = $org | .repo = $repo ]' >> workflow-runs-raw.json
done

# Merge the json arrays into a single array
jq -s 'add' workflow-runs-raw.json >> workflow-runs.json
