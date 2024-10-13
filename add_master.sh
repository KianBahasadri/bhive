#!/bin/bash
set -e

if [[ $(id -u) != 0 ]]
then
  echo Please run again as root
  exit
fi

if [[ $(basename $(pwd)) != bhive ]]
then
  echo Warning: not running from correct dir, exit now unless this is intentional
fi

if [[ $(dpkg -l | grep salt-common) == "" ]]
then
  wget https://repo.saltproject.io/bootstrap/stable/bootstrap-salt.sh
  chmod +x bootstrap-salt.sh
  ./bootstrap-salt.sh -M stable 3007.1
fi

cp -ar ./srv/salt/ /srv/
cp -a  ./etc/salt/cloud.providers /etc/salt/
cp -ar ./etc/salt/cloud.profiles.d/ /etc/salt/

