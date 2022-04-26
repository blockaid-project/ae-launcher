#!/usr/bin/env bash
set -e

run_mode=${1:?Must provide run mode}

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$SCRIPT_DIR"

git pull public main --ff-only

source set_credentials.sh

total_num_tasks_output=$(export ANSIBLE_STDOUT_CALLBACK=yaml; ansible-playbook print_total_num_tasks.yml 2>&1)
num_tasks_regex="total=([0-9]+)"
if [[ $total_num_tasks_output =~ $num_tasks_regex ]]
then
  total_num_tasks="${BASH_REMATCH[1]}"
else
  echo "couldn't parse output of 'print_total_num_tasks.yml'"
  echo "$total_num_tasks_output"
  exit 1
fi

printf "Number of measurement tasks = %d\n" "$total_num_tasks"

parallel="${PARALLEL:-$total_num_tasks}"
printf "Parallelism = %d\n" "$parallel"

batches=$(((total_num_tasks+parallel-1)/parallel))
printf "Running experiments in %d batch(es)\n" "$batches"

for ((i=0;i<batches;i++))
do
  printf "Starting batch %d / %d...\n" "$((i+1))" "$batches"
  ansible-playbook -f "$parallel" -e "ami_id=$AMI_ID" -e "run_mode=$run_mode" \
    -e "{\"parallel\": $parallel, \"batch_idx\": $i}" launch.yml
done

./cleanup.sh

printf "%s" "$run_mode" > /data/mode.txt

./plot/produce_plot_comparisons.sh
