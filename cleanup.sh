#!/usr/bin/env bash
source set_credentials.sh
ansible-playbook -f 6 "${params[@]}" cleanup.yml

