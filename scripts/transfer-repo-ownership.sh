#!/bin/bash

# Transfer a repository to new owner and copy teams permission
# Ref: https://docs.github.com/en/enterprise-cloud@latest/repositories/creating-and-managing-repositories/transferring-a-repository
#
# Usage: 
# Step 1: ./transfer-repo-ownership.sh <source-org> <target-org> <repo-name>

if [ $# -lt "3" ]; then
    echo "Usage: $0 <source-org> <target-org> <repo-name>" 
    exit 1
fi

sourceorg="$1"
targetorg="$2"
reponame="$3"

# Get list of teams associated with the repository
sourceteams=$(gh api /repos/$sourceorg/$reponame/teams)

for a_team in $sourceteams
do
    echo "Validating $teamname in $targetorg"

    teamname=$(echo $a_team | jq -r '.[].slug')
    targetorgteams=$(gh api /orgs/$targetorg/teams --jq '.[].name')

    # Check if team exists in targetorg, if not, create it
    if [[ ! $targetorgteams[*] =~ $teamname ]]; then
        echo "Creating team: $teamname"
        gh api -X POST /orgs/$targetorg/teams \
          -f name="$teamname" \
          -f description="Team transferred from $sourceorg" \
          -f privacy="closed"
    fi
done

# Transfer a repository
echo "Transferring repository ownershio from $sourceorg to $targetorg"
gh api -X POST /repos/$sourceorg/$reponame/transfer \
    -f 'new_owner'="$targetorg"

# Check if repository transferred to targetorg, if not, wait for 1 seconds
targetorgrepos=$(gh api /orgs/$targetorg/repos --jq '.[].name')
while [[ ! $targetorgrepos[*] =~ $reponame ]] ;
do
    sleep 1
    targetorgrepos=$(gh api /orgs/$targetorg/repos --jq '.[].name')
    # check the status of the HTTP response

done


# Copy teams permission to the repository
for a_team in $sourceteams
do
    # Get team permission from sourceorg
    teamname=$(echo $a_team | jq -r '.[].slug')
    permission=$(echo $a_team | jq -r '.[].permission')

    echo "Updating $teamname with permission:$permission in $targetorg"
    echo "/orgs/$targetorg/teams/$teamname/repos/$targetorg/$reponame -f permission=$permission"

    # Add or update team permission in targetorg
    gh api -X PUT /orgs/$targetorg/teams/$teamname/repos/$targetorg/$reponame \
        -f permission=$permission
done
