#!/usr/bin/env bash
set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$SCRIPT_DIR"

git pull public main --ff-only

source set_credentials.sh

params=("-e" "ami_id=$AMI_ID")
[[ -v TEST_RUN ]] && params+=("-e" "test_run=1")
ansible-playbook -f 6 "${params[@]}" launch.yml

./plot/produce_plot_comparisons.sh
