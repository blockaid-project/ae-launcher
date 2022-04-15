#!/usr/bin/env bash
set -e

run_mode=${1:?Must provide run mode}

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$SCRIPT_DIR"

git pull public main --ff-only

source set_credentials.sh

ansible-playbook -f 6 -e "ami_id=$AMI_ID" -e "run_mode=$run_mode" launch.yml
printf "%s" "$run_mode" > /data/mode.txt

./plot/produce_plot_comparisons.sh
