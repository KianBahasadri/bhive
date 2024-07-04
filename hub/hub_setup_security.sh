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
echo Setting up fail2ban
apt install -y fail2ban
echo Using default fail2ban configs for now

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
echo Configuring UFW rules
ufw --force reset
echo Fetching Cloudflare IPs
cloudflare_ips="$(curl -s 'https://www.cloudflare.com/ips-v4')";
                echo;
               "$(curl -s 'https://www.cloudflare.com/ips-v6')"
echo Setting Default UFW Rules
ufw default deny incoming
ufw default allow outgoing
echo Allowing Cloudflare IPs
for ip in $cloudflare_ips
do
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
echo Security Setup Finished

