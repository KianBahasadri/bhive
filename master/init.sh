#!/bin/bash
# See 'creating_the_master.txt'
set -e

if [[ $(id -u) != 0 ]]
then
  echo Please run again as root
  exit
fi

if [[ $(pwd) != "/home/ubuntu/bhive/master" ]]
then
  echo Warning: not running from correct dir , exit now unless this is intentional
  echo "($(pwd)) instead of /home/ubuntu/bhive/master"
  echo Hit any key to continue...
  read -r 
fi

if [[ $(dpkg -l | grep salt-common) == "" ]]
then
  wget https://repo.saltproject.io/bootstrap/stable/bootstrap-salt.sh
  chmod +x bootstrap-salt.sh
  ./bootstrap-salt.sh -M stable 3007.1
fi
echo -e "\n--- Salt is installed ---"

cp -ar ./srv/* /srv/
cp -ar ./etc/* /etc/
echo -e "\n--- Salt configs are in place ---"

if [[ $(salt-key --list=accepted | grep master) == '' ]]
then
  systemctl restart salt-minion
  sleep 2
  salt-key --accept=master --yes
fi
echo -e "\n--- Salt minion [master] is added ---"


