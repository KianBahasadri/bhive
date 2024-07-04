#!/bin/bash

if [[ $(whoami) != 'root' ]]
then
  echo this script needs to be run as root
  exit 1
fi

echo
echo Setting up fail2ban
apt install fail2ban
echo Using default fail2ban configs for now

echo
echo Setting up Nginx
apt install nginx

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
pip install -r ../hub/requirements.txt

echo
echo Starting add-server endpoint
fastapi run add_server.py --port 8001

echo
echo Configuring UFW rules
echo Fetching Cloudflare IPs
cloudflare_ips=$(curl -s 'https://www.cloudflare.com/ips-v4')\n \
               $(curl -s 'https://www.cloudflare.com/ips-v6')
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
ufw enable
ufw reload
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


