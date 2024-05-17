#!/usr/bin/env bash

# Function to print rainbow-colored loading dots
print_rainbow_dots() {
    colors=(31 33 32 36 34 35)  # Red, Yellow, Green, Cyan, Blue, Magenta
    for ((i = 0; i < 3; i++)); do
        echo -n " "
        for ((j = 0; j < 20; j++)); do
            color_index=$(( (i + j) % 6))
            echo -ne "\033[${colors[$color_index]}m●\033[0m"
            sleep 0.1
        done
        echo ""
    done
}

# Print loading screen
echo "==============================================="
echo "                Scrippy CLI                    "
echo "    🚀 Developed by Christopher Trauco 🦄"
echo "             Data Engineer 👷‍"
echo "==============================================="
echo "[Hello World!]"
echo "💻 LinkedIn: https://itrau.co/LinkedIn"
echo "📧 Email: hello@trau.co"
echo "🤖 GitHub: https://itrau.co/github"
echo "🐦 Twitter: https://itrau.co/twitter"
sleep 1

echo "✨ Initializing..."
print_rainbow_dots
sleep 1

echo "⚙️ Loading modules"
echo "🔧 Setting up the environment"
echo "🚀 Almost done..."
sleep 1
echo "🎉 Ready!"


# Sleep for 7 seconds before displaying the interactive shell prompts
sleep 7
# Function to create a new .myscripts directory and initialize it as a new Git repository with no history
create_new_repo() {
    read -p "Do you want to be taken to GitHub to create the repository? (y/n): " open_github
    if [ "$open_github" = "y" ]; then
        # Open the default system browser to the GitHub new repository page
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            xdg-open "https://github.com/new"
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            open "https://github.com/new"
        elif [[ "$OSTYPE" == "cygwin" ]]; then
            cygstart "https://github.com/new"
        elif [[ "$OSTYPE" == "msys" ]]; then
            start "https://github.com/new"
        else
            echo "Unsupported OS. Please open your browser and go to https://github.com/new manually."
        fi
        echo "Please create the repository and then press any key to continue..."
        read -n 1 -s
    fi

    read -p "Enter the URL of the newly created GitHub repository: " repo_url

    mkdir -p ~/.myscripts
    cd ~/.myscripts
    git init
    git checkout -b main

    # Create a README file
    cat <<EOL > README.md
# MyScripts Repository

## Purpose

This repository contains a collection of useful system scripts. The primary purpose is to manage and organize scripts that automate various tasks on your system.

## Contents

- Various system scripts for automation and convenience.
- Alias definitions for easy access to the scripts.

## Usage Instructions

### Step 1: Clone the Repository

To use the script, you need to clone the repository:

\`\`\`sh
git clone $repo_url
cd .myscripts
\`\`\`

### Step 2: Use the scrippy Alias

The \`scrippy\` alias allows you to create or edit scripts in the \`~/.myscripts\` directory from anywhere in the system. The scripts are automatically added, committed, and optionally pushed to the \`main\` branch.

### Example Usage

To create or edit a script:

\`\`\`sh
scrippy your_script_name.sh
\`\`\`

This command opens \`your_script_name.sh\` in Vim, located in the \`~/.myscripts\` directory, and automatically adds, commits, and optionally pushes the changes.

## Troubleshooting

If the \`scrippy\` alias is not found, you can manually add it to your shell configuration file:

### For \`.bashrc\`:
\`\`\`sh
echo "alias scrippy='function _scrippy() { vim ~/.myscripts/\$1; cd ~/.myscripts; git add \$1; git commit -m \"Add or update script \$1\"; [ \$PUSH -ne 0 ] && git push origin main; cd - > /dev/null; }; _scrippy'" >> ~/.bashrc
source ~/.bashrc
\`\`\`

### For \`.zshrc\`:
\`\`\`sh
echo "alias scrippy='function _scrippy() { vim ~/.myscripts/\$1; cd ~/.myscripts; git add \$1; git commit -m \"Add or update script \$1\"; [ \$PUSH -ne 0 ] && git push origin main; cd - > /dev/null; }; _scrippy'" >> ~/.zshrc
source ~/.zshrc
\`\`\`

## License

This project is licensed under the MIT License.
EOL

    git add README.md
    git commit -m "Add README with usage instructions"
    git remote add origin "$repo_url"
    git push -u origin main

    echo "New .myscripts repository created and set up with the remote repository URL."
}

# Function to list all branches and allow the user to select one
select_branch() {
    cd ~/.myscripts
    git fetch origin
    branches=$(git branch -r | grep -v '\->' | sed 's/origin\///')
    echo "Available branches:"
    echo "$branches"
    read -p "Enter the branch you want to checkout: " branch_name
    git checkout $branch_name
    echo "Checked out to branch: $branch_name"
}

# Function to download a pre-existing branch with system scripts
download_existing_branch() {
    read -p "Enter the URL of the pre-existing Git repository: " repo_url
    git clone "$repo_url" ~/.myscripts
    cd ~/.myscripts
    select_branch
    echo "Pre-existing branch downloaded and set up."
}

# Function to remove all scripts and destroy the repository
remove_and_destroy() {
    read -p "Are you sure you want to remove all scripts and destroy the repository? (y/n): " confirm
    if [ "$confirm" = "y" ]; then
        rm -rf ~/.myscripts
        sed -i '/alias scrippy/d' "$RC_FILE"
        source "$RC_FILE"
        echo ".myscripts directory and repository have been removed."
    else
        echo "Operation canceled."
    fi
}

# Function to use the pre-existing .myscripts directory
use_existing_directory() {
    if [ -d "$HOME/.myscripts" ]; then
        echo ".myscripts directory already exists. Configuring environment to use it."
    else
        echo ".myscripts directory does not exist. Please select another option."
    fi
}

# Determine the shell configuration file
if [ -n "$ZSH_VERSION" ]; then
    RC_FILE="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    RC_FILE="$HOME/.bashrc"
else
    echo "Unsupported shell."
    exit 1
fi

# Add alias to the shell configuration file
echo "alias scrippy='function _scrippy() { vim ~/.myscripts/\$1; cd ~/.myscripts; git add \$1; git commit -m \"Add or update script \$1\"; [ \$PUSH -ne 0 ] && git push origin main; cd - > /dev/null; }; _scrippy'" >> "$RC_FILE"

# Source the shell configuration file to apply changes
source "$RC_FILE"

# Interactive CLI menu
while true; do
    echo "Select an option:"
    echo "1. Create a new .myscripts repository with no history"
    echo "2. Download a pre-existing branch with system scripts"
    echo "3. Use existing .myscripts directory"
    echo "4. Remove all scripts and destroy the repository"
    echo "5. Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1) create_new_repo ;;
        2) download_existing_branch ;;
        3) use_existing_directory ;;
        4) remove_and_destroy ;;
        5) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid choice. Please select a valid option." ;;
    esac
done

