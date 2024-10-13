#!/bin/bash
set -e

if [[ $(id -u) != 0 ]]
then
  echo Please run again as root
  exit
fi

wget https://repo.saltproject.io/bootstrap/stable/bootstrap-salt.sh
chmod +x bootstrap-salt.sh
./bootstrap-salt.sh -M stable 3007.1



