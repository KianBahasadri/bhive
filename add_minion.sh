#!/bin/bash
set -e

if [[ $(id -u) != 0 ]]
then
  echo Please run again as root
  exit
fi

# TODO
apiAddress='127.0.0.1'
masterPubKey='xTIBA5rboUvnH4htodjb6e697QjLERt1NAB4mZqp8Dg='
wgAddress='10.101.0.0'

#apt install wireguard -y
wg genkey > /etc/wireguard/privatekey
chmod 400 /etc/wireguard/privatekey
publickey=$(cat /etc/wireguard/privatekey | wg pubkey)

myWgIp=$(curl -X POST "http://$address:8000/addWireguardPeer" \
  -H 'Content-Type: application/json' \
  -d "{ \"key\": \"$publickey\" }")

echo > /etc/wireguard/wg0.conf <<- END
[Interface]
Address = $myWgIp
PrivateKey = $(cat /etc/wireguard/privatekey)
ListenPort = 51820

[Peer]
PublicKey = $masterPubKey
Endpoint = $apiAddress
AllowedIPs = 0.0.0.0/0
END

systemctl enable --now wg-quick@wg0
ssh-keygen -f /root/.ssh/salt_key.pem -q -N ""


