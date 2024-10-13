#!/bin/bash

set -e

if [[ $# != 2 ]]
then
  echo "Usage: $0 <ip> <ssh_key_path>"
  exit
fi

num=$(ls | wc -l)

cat > minion$num.conf <<- END
minion$num:
  ssh_host: $1
  ssh_username: ubuntu
  key_filename: $2
  provider: my-saltify-config
END

