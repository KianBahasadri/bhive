#!/bin/bash

set -e

if [[ $- == *i* ]]
then
  echo WARNING: this script is not meant to be run manually
  exit 1
fi

echo
user="$1"
echo Using User: "$user"
function userdo() { setpriv --reuid="$user" "$@"; }

echo
echo Installing Python pip and venv
apt install -y python3-pip python3-venv

echo
echo Creating venv
userdo python3 -m venv venv

echo
echo Adding venv to PATH
echo "export PATH=$(realpath venv)/bin:$PATH" >> "$HOME/.bash_profile"
source "$HOME/.bash_profile"

echo
echo Installing python packages
userdo pip install -r requirements.txt

echo
echo Installing Nginx
apt install nginx

echo
echo Sym-Linking bhive_data.json
userdo ln -sf bhive_data_empty.json bhive_data.json
# This is required for build_nginx_conf.py

echo
echo Building Nginx conf
userdo python3 build_nginx_conf.py

echo
echo Sym-Linking nginx conf to buildpath
ln -sf "$buildpath"/nginx_bhive.conf /etc/nginx/conf.d/nginx_bhive.conf 

echo
echo Sym-Linking SSL Certificates
mkdir -p /etc/nginx/ssl
ln -sf "$(realpath keys/bahasadri.com.crt)" /etc/nginx/ssl/bahasadri.com.crt
ln -sf "$(realpath keys/bahasadri.com.key)" /etc/nginx/ssl/bahasadri.com.key

echo
echo Sym-Linking home.html
mkdir -p /etc/nginx/html
ln -sf "$(realpath home.html)" /etc/nginx/html/home.html

echo
echo Proxy Setup Finished


