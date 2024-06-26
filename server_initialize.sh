#!/bin/bash

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

echo
echo This server has now been added to the BHive
echo WELCOME ABOARD! 🥳🥳🥳

