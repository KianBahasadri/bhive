#!/bin/bash

set -e

if [[ $(whoami) != 'root' || ! -d keys || $# != 1]]
then
  echo To run this script, please ensure you have:
  echo 1. Run it directly inside the hub directory from the bhive github repo
  echo 2. Run it as root
  echo 3. Created a directory called keys with your ssl files
  echo 4. Passed the name of the user you would like to use as the first argument
  exit 1
fi

echo
user="$1"
echo Using User: "$user"
alias runuser="setpriv --reuid=$user"

echo
echo Setting buildpath
runuser mkdir build
buildpath=$(realpath ./build)
echo Buildpath Set: "$buildpath"

echo
echo Sym-Linking bhive_data.json
runuser ln -sf bhive_data_empty.json bhive_data.json

echo 
echo Updating Packages
apt update

echo
echo Setting up fail2ban
apt install -y fail2ban
echo Using default fail2ban configs for now

echo
echo Installing python packages
apt install -y python3-pip
runuser pip install -r requirements.txt

echo
echo Installing Nginx
apt install nginx
echo Building Nginx conf
runuser ./rebuild_nginx_conf.py
echo Sym-Linking nginx conf to buildpath
ln -sf "$buildpath"/nginx_bhive.conf /etc/nginx/conf.d/nginx_bhive.conf 
echo Sym-Linking SSL Certificates
mkdir /etc/nginx/ssl
ln -sf ./keys/bahasadri.com.crt /etc/nginx/ssl/bahasadri.com.crt
ln -sf ./keys/bahasadri.com.key /etc/nginx/ssl/bahasadri.com.key
echo Sym-Linking home.html
mkdir /etc/nginx/html
ln -sf home.html /etc/nginx/html/home.html

echo
echo Overwrting ssh_config
echo Disabling ssh password authentication
cat > "$buildpath"/ssh_config <<- END
Host *
  PasswordAuthentication no
  ChallengeResponseAuthentication no
  PubkeyAuthentication yes
  SendEnv LANG LC_*
  HashKnownHosts yes
END
ln -sf /etc/ssh_config "$buildpath"/ssh_config
chmod 444 "$buildpath"/ssh_config

echo
echo Starting add-server endpoint
runuser fastapi run add_server.py --port 8001

echo
echo Configuring UFW rules
ufw --force reset
echo Fetching Cloudflare IPs
cloudflare_ips="$(curl -s 'https://www.cloudflare.com/ips-v4')";
                echo;
               "$(curl -s 'https://www.cloudflare.com/ips-v6')"
echo Setting Default UFW Rules
ufw default deny incoming
ufw default deny outgoing
echo Allowing Cloudflare IPs
for ip in $cloudflare_ips; do
    ufw allow from "$ip" to any port 443 proto tcp
done
echo Allowing all SSH traffic
ufw allow ssh
echo Reloading and Enabling ufw
ufw --force enable
echo "UFW rules updated."

echo
echo removing sudo group
echo TODO

echo
echo setting new root user password
echo TODO

echo
echo The hub has been prepared
echo Go forth and achieve greatness


