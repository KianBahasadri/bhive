#!/bin/bash

if [[ $(whoami) != 'root' ]]
then
  echo this script needs to be run as root
  exit 1
fi

if [[ $# != 1 ]]
then
  echo 'Usage: ./server_initialize.sh <ssh private key>'
  exit 1
fi

echo
echo Installing Required Packages
sudo apt install unattended-upgrades
echo TODO: make sure this auto configures or do it manually if not

echo
echo Setting Permissions on Keyfile
keyfile="$1"
chmod 400 "$keyfile"

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
cat > diagnostic.txt <<- END
{
  "cores": $cores,
  "ram": $ram,
  "free space": $freespace,
  "total space": $totalspace
}
END

echo
echo Signing message with private key
echo TODO: implement this

echo
echo Sending message to https://bahasadri.com/add-server
curl --upload-file diagnostic.txt https://bahasadri.com/add-server > ~/ssh_key.pem
chmod 400 ~/ssh_key.pem

echo
echo Openining ssh access from orchestrator server

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

