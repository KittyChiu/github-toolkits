#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Save Slack notes
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description Save Slack notes to GitHub repo
# @raycast.author Kitty Chiu
# @raycast.authorURL https://github.com/KittyChiu
# @raycast.argument1 { "type": "text", "placeholder": "Slack permalink", "percentEncoded": false }

# Configuration
repo="<owner>/<repo>"
datetimestamp=$(date +"%Y-%m-%dT%H%M")
temp_file="$datetimestamp-comment_body.txt"
llm_model="<model name>" # e.g. llama3

# Create a blank issue with pre-populated label, title and body
issue_url=$(gh issue create -R $repo --label "slack-notes" --title "Slack thread $datetimestamp" --body $1)

# Extract Slack thread with gh-slack
comment_url=$(gh slack -i $issue_url $1)

# Extract the output of gh-slack
comment_id="${comment_url##*issuecomment-}"
comment_body=$(gh api /repos/$repo/issues/comments/$comment_id | jq -r '.body';)
echo $comment_body > $temp_file
encoded_comment_body=$(jq -s -R -r @uri $temp_file) 

# Run ollama locally to summarise and give a title to the notes 
summary=$(ollama run $llm_model summarise $encoded_comment_body)
title=$(ollama run $llm_model "Suggest one title to notes in $encoded_comment_body")
trimmed_title=$(echo $title | sed -n -e 's/^.*"\([^"]*\)".*$/\1/p' -e 's/^.*\*\*\([^*]*\)\*\*.*$/\1/p')

# Update issue with AI-generated summary and title
current_body=$(gh issue view $issue_url --json 'body' -q '.body')
new_body="$current_body - $summary"
gh issue edit $issue_url --body "$new_body" 
gh issue edit $issue_url --title "$trimmed_title"

# Cleanup
rm $temp_file