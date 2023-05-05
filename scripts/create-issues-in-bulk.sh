#!/bin/bash
# DOT NOT REMOVE TRAILING NEW LINE IN THE INPUT CSV FILE

# Usage: 
# Step 1: Create a list of issues in a csv file, 1 per line, with a trailing empty line at the end of the file
# Step 2: ./create-issues-in-bulk.sh users.csv <org> <repo>
#
# Sample lines in the file
# title_1,some body context
# title_2,http://website.com
#

if [ $# -lt "4" ]; then
    echo "Usage: $0 <tasks-file-name> <org> <repo> <label>"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "File $1 does not exist"
    exit 1
fi

filename="$1"
org="$2"
repo="$3"
label="$4"

while IFS=, read -r title body
do

    gh issue create --title "$title" --repo $org/$repo --label "$label" --body "$body"
    sleep 3

done < "$filename"
