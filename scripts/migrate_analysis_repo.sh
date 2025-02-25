# Shell script to find large files and commits in a git repository
# This script searches for commits larger than 2GB and files larger than 100MB in a git repository.
# Usage:
# 1. Clone git repo locally 
# 2. Save this script as analyse-repo.sh
# 3. chmod +x analyse-repo.sh
# 4. ./analyse-repo.sh

#!/bin/bash

# FILE_THRESHOLD size in bytes (100MB)
FILE_THRESHOLD=$((100 * 1024 * 1024))
# COMMIT_THRESHOLD size in bytes (2GB)
COMMIT_THRESHOLD=$((2 * 1024 * 1024 * 1024))

# Get the list of commits
commits=$(git rev-list --all)

###################################################
# Search for commits larger than 2GB
###################################################


echo "Search for commits larger than $COMMIT_THRESHOLD bytes:"

# Initialize HEAD position counter
position=0
commit_count=0
# Iterate over each commit
for commit in $commits; do
  # Initialize total size
  total_size=0
  
  # Get the list of files in the commit and their sizes
  for file in $(git ls-tree -r --name-only "$commit"); do
    file_size=$(git cat-file -s "$commit:$file")
    total_size=$((total_size + file_size))
  done
  
  # Calculate the position relative to HEAD
  position_str=$([ $position -eq 0 ] && echo "HEAD" || echo "HEAD~$position")
  
  # DEBUG
  # echo "[debug] Commit $commit ($total_size bytes) in position $position_str"
  
  if [ "$total_size" -gt "$COMMIT_THRESHOLD" ]; then
    # Print the commit hash, total size, and position in tabular format
    echo "Commit $commit ($total_size bytes) in position $position_str"
    commit_count=$((commit_count + 1))
  fi

  # Increment position counter
  position=$((position + 1))
done
echo "Total $commit_count commits larger than $COMMIT_THRESHOLD bytes found."


###################################################
# Search for file objects larger than 100MB 
###################################################

echo "Search for files larger than $FILE_THRESHOLD bytes in each commit:"

file_count=0
# Iterate over each commit
for commit in $commits; do
  # Get the list of files in the commit
  git ls-tree -r -z --name-only "$commit" | while IFS= read -r -d '' file; do
    # Get the file size
    file_size=$(git cat-file -s "$commit:$file")

		# DEBUG
		# echo "[debug] File $file ($file_size bytes) in commit: $commit"

    # Check if the file size is greater than the FILE_THRESHOLD
    if [ "$file_size" -gt "$FILE_THRESHOLD" ]; then
      echo "$file ($file_size bytes) in commit: $commit"
      file_count=$((file_count + 1))
    fi
  done
done
echo "Total $file_count files larger than $FILE_THRESHOLD bytes found."
