#!/bin/bash

if [[ $# != 1 ]]
then
  echo "Usage: find_ssh_port.sh <client ip>"
  exit 1
fi

ss -tnp | grep $1 | grep -oE "[0-9]*\s*$"

