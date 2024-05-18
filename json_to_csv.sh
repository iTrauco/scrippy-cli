#!/bin/zsh

################################################################################
# Script: json_to_csv.sh
# Description: 🌟 This script converts JSON data to CSV format using jq and csvkit. 🌟
# Usage: ./json_to_csv.sh
# Author: [Your Name] 💻
# Date: [Date] 📅
# Dependencies: csvkit, jq 🛠️
################################################################################

# Function to check if a command is available
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if jq is installed
if ! command_exists jq; then
    echo "❌ jq is not installed locally. ⚠️"

    # Prompt user to install jq using apt on Debian-based systems
    if command_exists apt; then
        echo "Do you want to install jq? (y/n)"
        read -r choice
        if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
            sudo apt update
            sudo apt install jq
        else
            echo "jq is required for this script to work. Please install jq and run the script again."
            exit 1
        fi
    # Prompt user to install jq using homebrew on macOS
    elif command_exists brew; then
        echo "Do you want to install jq? (y/n)"
        read -r choice
        if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
            brew install jq
        else
            echo "jq is required for this script to work. Please install jq and run the script again."
            exit 1
        fi
    else
        echo "jq is required for this script to work. Please install jq manually and run the script again."
        exit 1
    fi
fi

# Spinner function
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " %s " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b"
    done
    printf "   \b\b\b"
}

# Function to convert JSON to CSV
json_to_csv() {
    # Check if JSON file exists
    if [ ! -f "$1" ]; then
        echo "❌ JSON file $1 not found. ⚠️"
        exit 1
    fi

    # Extract headers using jq
    headers=$(jq -r 'first | keys_unsorted | @csv' "$1")

    # Convert JSON to CSV using jq and csvformat
    jq -r '(map(.[] | tostring) | join(",")), (.[] | map(. | tojson) | join(",") ) | @csv' "$1" | csvformat -T -U 1 > "$2" &
    spinner $!
    wait $!

    echo "✅ Conversion completed successfully! 🎉"
}

# List .json files in the current directory
json_files=$(ls *.json 2>/dev/null)

if [ -z "$json_files" ]; then
    echo "❌ No JSON files found in the current directory. ⚠️"
    exit 1
fi

# Display list of JSON files and prompt for selection
echo "📂 List of JSON files in the current directory: 📂"
select json_file in $json_files; do
    if [ -n "$json_file" ]; then
        break
    else
        echo "❌ Invalid selection. Please try again. ⚠️"
    fi
done

# Prompt for output file name
read -p "Enter output CSV file name (press Enter for default 'output.csv'): " output_name

# Use default name if input is empty
if [ -z "$output_name" ]; then
    output_name="output.csv"
fi

# Convert JSON to CSV
json_to_csv "$json_file" "$output_name"

