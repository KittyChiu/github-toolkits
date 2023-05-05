#!/bin/bash

# Objective: Remove teams with zero membership
# Usage:
# Step 1: ./clean-up-teams.sh <org>

if [ -z "$1" ]; then
    echo "Usage: $0 <org>"
    exit 1
fi

org=$1

all_teams=$(gh api /orgs/$org/teams -q '.[].slug')

for a_team in $all_teams
do
    if [ $(gh api /orgs/$org/teams/$a_team/members | jq length) -eq 0 ]; then
        # echo $a_team
        gh api -X DELETE /teams/$a_team
    fi
done
