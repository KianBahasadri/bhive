#!/bin/bash
# - install bootstrap
# - Salt states take care of the rest

set -e

if [[ $(id -u) != 0 ]]
then
  echo Please run again as root
  exit
fi

if [[ $(pwd) != "/home/ubuntu/bhive/master" ]]
then
  echo Warning: not running from correct dir , exit now unless this is intentional
  echo "($(pwd)) instead of /home/ubuntu/bhive/master"
  echo Hit any key to continue...
  read -r 
fi

if [[ $(dpkg -l | grep salt-common) == "" ]]
then
  wget https://repo.saltproject.io/bootstrap/stable/bootstrap-salt.sh
  chmod +x bootstrap-salt.sh
  ./bootstrap-salt.sh -M stable 3007.1
fi

echo 'id: master' > /etc/salt/minion.d/id.conf
echo 'master: 127.0.0.1' > /etc/salt/minion.d/master.conf
#systemctl restart salt-minion
#salt-key --accept=master --yes

cp -ar ./srv/salt/ /srv/
cp -ar ./etc/salt/ /etc/

echo '''
--------------------------



#apt update
#apt upgrade -y
#cat package_list.txt | xargs apt install -y


wg genkey > /etc/wireguard/privatekey
chmod 400 /etc/wireguard/privatekey
privatekey=$(cat /etc/wireguard/privatekey)
wg pubkey < $(echo "$privatekey") > /etc/wireguard/publickey

cat > /etc/wireguard/wg0.conf <<-END
[Interface]
PrivateKey=$privatekey

systemctl enable docker

docker compose up
''' > /dev/null
