#!/bin/bash

if [[ $(whoami) != 'root' ]]
then
  echo this script needs to be run as root
  exit 1
fi

if [[ ! -d keys ]]
then
  echo create keys directory and put SSL certificates inside
  exit 1
fi

echo
echo Setting buildpath
mkdir build
buildpath=$(realpath ./build)
echo Buildpath Set: "$buildpath"

echo
echo Sym-Linking bhive_data.json
ln -s bhive_data_empty.json bhive_data.json

echo
echo Setting up fail2ban
apt install fail2ban
echo Using default fail2ban configs for now

echo
echo Installing python packages
apt install python3-pip
pip install -r requirements.txt

echo
echo Installing Nginx
apt install nginx
echo Building Nginx conf
./rebuild_nginx_conf.py
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
ln -sf /etc/ssh_config "$buildpath"/config

echo
echo Starting add-server endpoint
fastapi run add_server.py --port 8001

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


