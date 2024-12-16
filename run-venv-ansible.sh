#!/bin/sh

set -eu

venv_path="venv"
if [ ! -e "$venv_path" ]
then
  echo "Virtual environment not found in $venv_path, creating new one"
  python3 -m venv --upgrade-deps "$venv_path"

  echo "Installing ansible in virtual environment"
  "$venv_path/bin/pip" install --upgrade ansible ansible-core
fi

exec venv/bin/ansible-playbook config.yml -K "$@"
