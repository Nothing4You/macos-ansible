#!/bin/sh

set -eu

# this file is required for Command Line Tools to show up in softwareupdate
clt_in_progress_file="/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress"
touch "$clt_in_progress_file"

echo "Checking for Command Line Tools in softwareupdate"
clt_version="$(softwareupdate -l | awk -F'-' '/Label: Command Line Tools/{ print $2 }' | tail -1)"

if [ -n "$clt_version" ]
then
  echo "Installing Command Line Tools $clt_version"
  softwareupdate -i "Command Line Tools for Xcode-$clt_version" --verbose
else
  echo "No Command Line Tools update found"
fi
rm "$clt_in_progress_file"

venv_path="venv"
if [ ! -e "$venv_path" ]
then
  echo "Virtual environment not found in $venv_path, creating new one"
  python3 -m venv --upgrade-deps "$venv_path"
fi

echo "Installing ansible in virtual environment"
"$venv_path/bin/pip" install --upgrade ansible ansible-core

if ! command -v brew > /dev/null 2>&1
then
  echo "Installing homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
