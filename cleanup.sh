#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$SCRIPT_DIR"
source set_credentials.sh
ansible-playbook -f 6 "${params[@]}" cleanup.yml

