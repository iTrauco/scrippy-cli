#!/usr/bin/env bash


# Source the shell's configuration file to load aliases
if [ -n "$ZSH_VERSION" ]; then
    source "$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    source "$HOME/.bashrc"
fi

# Check if Zsh is installed
if command -v zsh >/dev/null 2>&1; then
    shell="zsh"
    rcfile="$HOME/.zshrc"
else
    shell="bash"
    rcfile="$HOME/.bashrc"
fi

# Function to add or update an alias
add_alias() {
    alias_name="$1"
    alias_command="$2"

    # Check if alias exists
    if grep -q "alias $alias_name=" "$rcfile"; then
        # Update existing alias
        sed -i "s/^alias $alias_name=.*/alias $alias_name='$alias_command'/" "$rcfile"
    else
        # Add new alias
        echo "alias $alias_name='$alias_command'" >> "$rcfile"
    fi
}

# Define your aliases here
add_alias "audio2text" "audio2text_func"

# Function to manage audio2text alias
audio2text_func() {
    # Check if venv is activated
    if [ -z "${VIRTUAL_ENV}" ]; then
        echo "Activating virtual environment..."
        source venv/bin/activate || return 1
    fi

    # Install required packages
    echo "Installing required packages..."
    pip3 install speechrecognition pyttsx3 || return 1

    echo "Installation complete."
}

echo "Aliases updated in $rcfile."
