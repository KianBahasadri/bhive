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

if ping -c 1 10.101.0.0 &> /dev/null
then
  echo -e "\n--- Wiregaurd Host Reachable ---\n"

else
  if [[ $(dpkg -l | grep wireguard) == '' ]]
  then
    apt update
    apt upgrade -y
    apt install wireguard -y
  fi
  echo -e "\n--- Wireguard is installed ---\n"

  if [[ -f /etc/wireguard/privatekey ]]
  then
    rm /etc/wireguard/privatekey
  fi
  wg genkey > /etc/wireguard/privatekey
  chmod 400 /etc/wireguard/privatekey
  publickey=$(cat /etc/wireguard/privatekey | wg pubkey)
  echo "$publickey" > /etc/wireguard/publickey
  echo -e "\n--- Wireguard keys exist ---\n"

  api_response=$(curl -X POST "http://$apiAddress:80/addWireguardPeer" \
    -H 'Content-Type: application/json' \
    -d "{ \"key\": \"$publickey\" }")

  myWgIp=$(echo "$api_response" | head -n 1)
  masterPubKey=$(echo "$api_response" | tail -n 1 $api_reponse)

  cat > /etc/wireguard/wg0.conf <<- END
[Interface]
Address = $myWgIp/24
PrivateKey = $(cat /etc/wireguard/privatekey)
ListenPort = 51820

[Peer]
PublicKey = $masterPubKey
Endpoint = $apiAddress:51820
AllowedIPs = 10.101.0.0/32
PersistentKeepalive = 25
END
  echo -e "\n--- Wireguard config exists ---\n"

  wg-quick down wg0
  wg-quick up wg0
  echo -e "\n--- Wireguard interface is running ---\n"
fi


if [[ -f /root/.ssh/salt_key.pem ]]
then
  rm -rf /root/.ssh/salt_key.pem
fi
ssh-keygen -f /root/.ssh/salt_key.pem -q -N ""
echo -e "\n--- SSH key salt_key.pem exists ---\n"

curl -X 'POST' "http://$wgAddress:80/addSaltifyMinion" \
  -H 'Content-Type: multipart/form-data' \
  -F 'keyfile=@/root/.ssh/salt_key.pem;type=application/x-x509-ca-cert'
echo -e "\n--- Server added to saltify ---\n"

