#!/usr/bin/env bash
set -e

#######################################
# Fish Shell Plugins Setup Script
#######################################

cat << 'EOF'
===============================
 Fish Shell Plugins Setup
===============================
This script will help you set up useful Fish shell plugins
using the fisher plugin manager.
EOF

# Dependency check
for cmd in fish curl; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: '$cmd' is not installed."
        exit 1
    fi
done

echo
read -rp "Do you want to install the plugin manager 'fisher'? (Y/n): " install_fisher
install_fisher=${install_fisher:-Y}

if [[ ! "$install_fisher" =~ ^[Yy]$ ]]; then
    echo "Skipping fisher installation. Exiting."
    exit 0
fi

# Install fisher (via fish shell)
echo
echo "Installing fisher..."
fish -c '
curl -fsSL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish \
| source
fisher install jorgebucaran/fisher
'
echo "Fisher installed successfully."

# Plugin list
declare -A plugins=(
    [1]="edc/bass"
    [2]="jorgebucaran/nvm.fish"
    [3]="kpbaks/ros2.fish"
)

cat << 'EOF'

--------------------------------
 Available Fish Plugins
--------------------------------
1. edc/bass
   Use Bash utilities in Fish
   https://github.com/edc/bass

2. jorgebucaran/nvm.fish
   Node Version Manager for Fish
   https://github.com/jorgebucaran/nvm.fish

3. kpbaks/ros2.fish
   ROS 2 environment setup for Fish
   https://github.com/kpbaks/ros2.fish

Type plugin numbers separated by spaces (e.g. 1 3),
or type 'all' to install all plugins.
EOF

# Read user selection
echo
read -rp "Your selection: " plugin_selection

if [[ -z "$plugin_selection" ]]; then
    echo "No plugins selected. Exiting."
    exit 0
fi

# Install plugins
install_plugin() {
    local plugin="$1"
    echo "Installing $plugin..."
    fish -c "fisher install $plugin"
    echo "$plugin installed successfully."
}

shopt -s nocasematch
if [[ "$plugin_selection" == "all" ]]; then
    for plugin in "${plugins[@]}"; do
        install_plugin "$plugin"
    done
else
    for num in $plugin_selection; do
        plugin="${plugins[$num]}"
        if [[ -n "$plugin" ]]; then
            install_plugin "$plugin"
        else
            echo "Invalid selection: $num (skipped)"
        fi
    done
fi
shopt -u nocasematch

# Done
echo
echo "All selected plugins have been processed."

