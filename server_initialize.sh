#!/bin/bash

set -e

if [[ $(whoami) != 'root' ]]
then
  echo To run this script, please ensure you have:
  echo 1. Run it as root
  exit 1
fi

echo apt updating and upgrading
apt update
apt upgrade -y

echo
echo Installing Required Packages
apt install unattended-upgrades

echo
echo Running Hardware Diagnostic
cores=$(nproc --all)
ram=$(awk '/MemTotal/ { printf "%.3f \n", $2/1024/1024 }' /proc/meminfo)
totalspace=$(( $(df / --output=size | tail -1) /1024/1024 ))
freespace=$(( $(df / --output=avail | tail -1) /1024/1024 ))

echo
echo Diagnostic Complete:
echo $cores CPU cores
echo $ram GB of ram
echo $totalspace GB of total disk space
echo $freespace GB of free disk space
diagnostic=$(cat <<- END
{
  "cores": $cores,
  "ram": $ram,
  "free_space": $freespace,
  "total_space": $totalspace
}
END
)

echo
echo Sending message to https://bahasadri.com/add-server
curl -s -x POST https://bahasadri.com/add-server \
     -d "$diagnostic" \
     -H "Content-Type: application/json" \
     -o "$HOME/ssh_key.pem"
chmod 400 "$HOME/ssh_key.pem"

echo
echo Openining ssh access from hub
ssh -N -o StrictHostKeyChecking=accept-new -R localhost:0:localhost:22 ssh.bahasadri.com -i ssh_key.pem

echo
echo Overwrting ssh_config
echo Disabling ssh password authentication
cat > /etc/ssh/ssh_config <<- END
Host *
  PasswordAuthentication no
  ChallengeResponseAuthentication no
  PubkeyAuthentication yes
  SendEnv LANG LC_*
  HashKnownHosts yes
END

echo
echo setting up ufw
ufw enable
ufw default deny incoming
echo Current UFW Settings:
ufw status verbose

echo
echo removing sudo group
echo TODO

echo
echo setting new root user password
echo TODO

echo
echo This server has now been added to the BHive
echo WELCOME ABOARD! 🥳🥳🥳

