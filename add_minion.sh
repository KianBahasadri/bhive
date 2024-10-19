#!/bin/bash
set -e

if [[ $(id -u) != 0 ]]
then
  echo Please run again as root
  exit
fi

# TODO
apiAddress='salt.bahasadri.com'
wgAddress='10.101.0.0'

if [[ $(dpkg -l | grep wireguard) == '' ]]
then
  apt update
  apt upgrade -y
  apt install wireguard -y
fi

rm /etc/wireguard/privatekey
wg genkey > /etc/wireguard/privatekey
chmod 400 /etc/wireguard/privatekey
publickey=$(cat /etc/wireguard/privatekey | wg pubkey)
echo "$publickey" > /etc/wireguard/publickey

api_response=$(curl -X POST "http://$apiAddress:80/addWireguardPeer" \
  -H 'Content-Type: application/json' \
  -d "{ \"key\": \"$publickey\" }")

myWgIp=$(echo "$api_response" | head -n 1)
masterPubKey=$(echo "$api_response" | tail -n 1 $api_reponse)

cat > /etc/wireguard/wg0.conf <<- END
[Interface]
#Address = $myWgIp
PrivateKey = $(cat /etc/wireguard/privatekey)
ListenPort = 51820

[Peer]
PublicKey = $masterPubKey
Endpoint = $apiAddress:51820
AllowedIPs = 10.101.0.0/24
PersistentKeepalive = 25
END

wg-quick down wg0
wg-quick up wg0

if ! [[ -f /root/.ssh/salt_key.pem ]]
then
  ssh-keygen -f /root/.ssh/salt_key.pem -q -N ""
fi



