#!/bin/bash

set -e

if [[ $- == *i* ]]
then
  echo WARNING: this script is not meant to be run manually
  exit 1
fi

echo
echo Installing Python pip and venv
apt install -y python3-pip python3-venv

echo
echo Creating venv
userdo python3 -m venv venv

echo
echo Adding source venv to bash startup file
if [[ -f "$HOME/.profile" ]]
then
  bashstartup="$HOME/.profile"
else
  bashstartup="$HOME/.bash_profile"
fi
echo "Bash startup file detected as: $bashstartup"
echo "source $(realpath venv)/bin/activate" >> "$bashstartup"
source "$bashstartup"

echo
echo Installing python packages
pip install -r requirements.txt

echo
echo Installing Nginx
apt install nginx

echo
echo Sym-Linking bhive_data_empty.json
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
echo Sym-Linking bhive_data.json
mkdir -p /etc/nginx/html
ln -sf "$(realpath bhive_data.json)" /etc/nginx/html/bhive_data.json

echo
echo Making fastapi logging directory
mkdir -p /var/log/fastapi
chmod 755 /var/log/fastapi

echo
echo Starting fastapi add-server endpoint
userdo fastapi run add_server.py --port 8001 &> /var/log/fastapi/add_server.log &
chmod 666 /var/log/fastapi/add_server.log

echo
echo Proxy Setup Finished


