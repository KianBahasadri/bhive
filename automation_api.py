import re
import subprocess
from pathlib import Path

from fastapi import FastAPI
from fastapi.middleware.httpsredirect import HTTPSRedirectMiddleware
from pydantic import BaseModel

app = FastAPI()
#app.add_middleware(HTTPSRedirectMiddleware)

class wgPubKey(BaseModel):
  key: str


@app.post('/addWireguardPeer', response_class=PlainTextResponse)
def addPeer(wgPubKey: wgPubKey):
  """
  "Key generation, distribution, and revocation can be handled in larger deployments using a separate service like Ansible or Kubernetes Secrets."  
  So I made my own service.  
  https://docs.sweeting.me/s/wireguard#How-WireGuard-Manages-Keys
  """
  public_key = wgPubKey.key
  # validate wireguard key
  # https://lists.zx2c4.com/pipermail/wireguard/2020-December/006222.html
  if not re.match("^[A-Za-z0-9+/]{42}[AEIMQUYcgkosw480]=$", public_key):
    return f"Invalid public key detected: {public_key}"
  
  with open('/etc/wireguard/wg0.conf', 'r+') as file:
    lines = file.readlines()
    # second line of wg0.conf is ```<int> peers registered```
    num_peers = int(lines[1].split()[1])
    num_peers += 1
    lines[1] = f"# {num_peers} peers registered"
    
    new_ip = f"10.101.0.{num_peers}"
    new_peer = \
    "[Peer]"      # implicit string concatonation is crazy bruh
    f"PublicKey = {public_key}"
    f"AllowedIPs = {new_ip}"
    "PersistentKeepalive = 25"

    file.seek(0)
    for line in lines:
      file.write(line)
    file.write(new_peer)
    
    # Add new peer without distruption
    # https://ubuntu.com/server/docs/common-tasks-in-wireguard-vpn
    subprocess.run(['systemctl', 'reload', 'wg-quick@wg0'])
  return new_ip



