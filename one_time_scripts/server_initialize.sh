#!/bin/bash

if [[ $# != 1 ]]
then
  echo 'Usage: ./server_initialize.sh <ssh private key>'
  exit 1
fi
keyfile="$1"

if  [[ $(stat -c "%a" "$keyfile") != 400 ]]
then
  echo "Set $keyfile permissions to 400"
  exit 1
fi

echo Hardening Local Security
./apply_security_rules.sh server_security_rules.json

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
#curl --upload-file diagnostic.txt https://bahasadri.com/add-server

echo Openining ssh access from orchestrator server
ssh -N -o StrictHostKeyChecking=accept-new -R localhost:0:localhost:22 ssh.bahasadri.com -i droplet.pem

echo
echo This server has now been added to the BHive
echo WELCOME ABOARD! 🥳🥳🥳

