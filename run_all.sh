#!/usr/bin/env bash
set -e

CREDENTIALS_FILE=".credentials.sh"
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$SCRIPT_DIR"

git pull public main --ff-only

if [ ! -f "$CREDENTIALS_FILE" ]
then
  echo "AWS credentials not found..."
  read -r -p 'AWS Access Key ID: ' access_key_id
  read -r -p 'AWS Secret Access Key: ' secret_access_key
  read -r -p 'AWS region (e.g., us-west-2): ' region

tee "$CREDENTIALS_FILE" <<EOF >/dev/null
export AWS_REGION=${region}
export AWS_ACCESS_KEY=${access_key_id}
export AWS_SECRET_KEY=${secret_access_key}
EOF
fi

source "$CREDENTIALS_FILE"

if [[ -v TEST_RUN ]]
then
    params=("-e" "test_run=true")
else
    params=("-e" "test_run=false")
fi

ansible-playbook -f 6 "${params[@]}" launch.yml

./plot/produce_plot_comparisons.sh
