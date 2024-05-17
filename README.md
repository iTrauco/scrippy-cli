# MyScripts Repository

## Purpose

This repository contains a collection of useful system scripts. The primary purpose is to manage and organize scripts that automate various tasks on your system.

## Contents

- Various system scripts for automation and convenience.
- Alias definitions for easy access to the scripts.

## Usage Instructions

### Step 1: Clone the Repository

To use the script, you need to clone the repository:

```sh
git clone https://github.com/iTrauco/scrippy-cli.git
cd .myscripts
```

### Step 2: Use the scrippy Alias

The `scrippy` alias allows you to create or edit scripts in the `~/.myscripts` directory from anywhere in the system. The scripts are automatically added, committed, and pushed to the `main` branch.

### Example Usage

To create or edit a script:

```sh
scrippy your_script_name.sh
```

This command opens `your_script_name.sh` in Vim, located in the `~/.myscripts` directory, and automatically adds, commits, and pushes the changes.

## License

This project is licensed under the MIT License.
