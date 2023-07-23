#!/bin/bash

# Function to search for "Status: draft" in the first 10 lines of a file
function search_in_file {
    if head -n 10 "$1" | grep -q "Status: draft"; then
        echo "Found 'Status: draft' in: $1"
    fi
}

# Function to process directories recursively
function process_directory {
    for item in "$1"/*; do
        local base_name=$(basename "$item")
        if [ "$base_name" = "venv" ]; then
            continue
        fi

        if [ -d "$item" ]; then
            process_directory "$item"
        elif [ -f "$item" ] && [[ "$item" == *.md ]]; then
            search_in_file "$item"
        fi
    done
}

# Start processing from the current directory
current_directory=$(pwd)
process_directory "$current_directory"
