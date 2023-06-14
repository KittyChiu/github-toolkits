#!/bin/bash
# Add a GitHub team to GitHub repositories with write permission access 

# Usage: 
# Step 1: Create a list of repos in a csv file, 1 per line, with a trailing empty line at the end of the file
# Step 2: Run ./add-team-to-repository.sh <team name> <target org> <permission> <repo list file>.csv
#
# Sample lines in the file
# repo1
# repo2
#
# Tips:
# - Apply `chmod +x *.sh` before executing.
# - Quick start for `gh api` - https://docs.github.com/en/rest/guides/getting-started-with-the-rest-api


if [ $# -lt "4" ]; then
    echo "Usage: $0 <team name> <target org> <permission> <repo list file>.csv"
    exit 1
fi

if [ ! -f "$4" ]; then
    echo "File $1 does not exist"
    exit 1
fi

teamname="$1"
targetorg="$2"
permission="$3"
filename="$4"

while IFS=, read -r repo_name
do
    echo "Updating $teamname with permission:$permission in $targetorg"
    echo "/orgs/$targetorg/teams/$teamname/repos/$targetorg/$repo_name -f permission=$permission"

    # Add or update team permission in targetorg
    gh api -X PUT /orgs/$targetorg/teams/$teamname/repos/$targetorg/$repo_name \
        -f permission=$permission
done < "$filename"