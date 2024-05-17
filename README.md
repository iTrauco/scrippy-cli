# MyScripts Repository

## Purpose

This repository contains a collection of useful system scripts. The primary purpose is to manage and organize scripts that automate various tasks on your system.

## Contents

- Various system scripts for automation and convenience.
- Function definitions for easy access to the scripts.

## Usage Instructions

### Step 1: Clone the Repository

To use the script, you need to clone the repository:

```sh
git clone <repository-url>
cd .myscripts
```

### Step 2: Make the Script Executable

Before running the script, make sure it has execute permission:

```sh
chmod +x myscripts.sh
```

### Step 3: Run the Script

You can now run the script:

```sh
./myscripts.sh
```

### Step 4: Use the scrippy Function

The `scrippy` function allows you to create or edit scripts in the `~/.myscripts` directory from anywhere in the system. The scripts are automatically added, committed, and pushed to the main branch.

#### Example Usage

To create or edit a script:

```sh
scrippy your_script_name.sh
```

This command opens `your_script_name.sh` in Vim, located in the `~/.myscripts` directory, and automatically adds, commits, and pushes the changes.

#### Troubleshooting

If the `scrippy` function is not found, you can manually add it to your shell configuration file:

For `.bashrc`:

```sh
echo "alias scrippy='f() { vim ~/.myscripts/\$1; cd ~/.myscripts; git add \$1; git commit -m \"Add or update script \$1\"; git push origin main; cd - > /dev/null; }; f'" >> ~/.bashrc
source ~/.bashrc
```

For `.zshrc`:

```sh
echo "alias scrippy='f() { vim ~/.myscripts/\$1; cd ~/.myscripts; git add \$1; git commit -m \"Add or update script \$1\"; git push origin main; cd - > /dev/null; }; f'" >> ~/.zshrc
source ~/.zshrc
```

#### Managing Tracked Scripts

You can manage your tracked scripts without initializing the entire CLI by using standard Git commands. Here are a few examples:

To add a new script:

1. Create or edit the script using `scrippy`:

```sh
scrippy new_script.sh
```

2. Save and exit Vim. The script will be automatically added, committed, and pushed.

To manually add, commit, and push changes:

1. Navigate to the `.myscripts` directory:

```sh
cd ~/.myscripts
```

2. Add the script:

```sh
git add script_name.sh
```

3. Commit the changes:

```sh
git commit -m "Update script_name.sh"
```

4. Push the changes:

```sh
git push origin main
```

