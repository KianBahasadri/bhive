#!/bin/bash

if [[ $(whoami) != 'root' ]]
then
  echo this script needs to be run as root
  exit 1
fi

echo
echo Setting up fail2ban
sudo apt install fail2ban
echo Using default fail2ban configs for now

echo
echo Setting up Nginx
sudo apt install nginx

echo
echo Overwrting ssh_config
echo Disabling ssh password authentication
cat > /etc/ssh_config <<- END
Host *
  PasswordAuthentication no
  ChallengeResponseAuthentication no
  PubkeyAuthentication yes
  SendEnv LANG LC_*
  HashKnownHosts yes
END

echo
echo Installing python packages
pip install -r requirements.txt

echo
echo Starting add-server endpoint
fastapi run add_server.py --port 8001

echo
echo removing sudo group
echo TODO

echo
echo setting new root user password
echo TODO

echo
echo The hub has been prepared
echo Go forth and achieve greatness


