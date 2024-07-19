#!/bin/bash

set -e

if [[ $(whoami) != 'root' || ! -d keys || $# != 1 ]]
then
  echo To run this script, please ensure you have:
  echo 1. Run it directly inside the hub directory from the bhive github repo
  echo 2. Run it as root
  echo 3. Created a directory called keys with your ssl files
  echo 4. Passed the name of the user you would like to use as the first argument
  exit 1
fi

echo """
████████╗██╗  ██╗███████╗    ██╗  ██╗██╗   ██╗██████╗
╚══██╔══╝██║  ██║██╔════╝    ██║  ██║██║   ██║██╔══██╗
   ██║   ███████║█████╗      ███████║██║   ██║██████╔╝
   ██║   ██╔══██║██╔══╝      ██╔══██║██║   ██║██╔══██╗
   ██║   ██║  ██║███████╗    ██║  ██║╚██████╔╝██████╔╝
   ╚═╝   ╚═╝  ╚═╝╚══════╝    ╚═╝  ╚═╝ ╚═════╝ ╚═════╝
"""

echo
user="$1"
echo Using User: "$user"
eval "function userdo() { setpriv --reuid=$user --regid=$user --init-groups"' $@; }'
export -f userdo

echo
echo Setting Environment Variables
HOME=$(su $user -c 'echo $HOME')
export HOME

echo 
echo Updating Packages
apt update
echo Upgrading Packages
apt upgrade -y

echo
echo Setting buildpath
userdo mkdir -p build
export buildpath=$(realpath ./build)
echo Buildpath Set: "$buildpath"

echo Running Setup Security
./hub_setup_security.sh
echo Running Setup Proxy
./hub_setup_proxy.sh

echo
echo The hub has been prepared
echo Go forth and achieve greatness


