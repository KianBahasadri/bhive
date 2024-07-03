from fastapi import FastAPI, Request
from pydantic import BaseModel
import json
import subprocess
import os

class Diagnostic(BaseModel):
  cores: int
  ram: str
  free_space: str
  total_space: str

template_server = {
  "service ids": [],
  "sshport": 49000,
  "resources": {
    "cores": 2,
    "ram": 4,
    "free space": 400,
    "total space": 500
  }
}

app = FastAPI()

@app.post("/add-server")
async def add_server(diagnostic: Diagnostic, request: Request):
  # Part 1: add server to bhive_data.json
    # Preparing Data
  new_server = template_server
  new_server['resources'] = diagnostic
  ip = request.client.host
  ssh_output = subprocess(['./find_ssh_port.sh', ip], capture_output=True).stdout
  new_server['sshport'] = ssh_output.stdout.strip()
    # Adding Data
  with open('bhive_data.json', 'rw') as bhive_file:
    bhive_str = bhive_file.readall()
    bhive_json = json.loads(bhive_str)
    bhive_json['servers'].append[new_server]
    bhive_file.seek(0)
    bhive_file.write(json.dumps(bhive_json))

  # Part 2: generate keyfile and return it
  keyname = ip.replace('.', '_') + '_ssh_key.pem'
  subprocess.run(["ssh-keygen", f"-f {keyname}", " -N ''"])
  with open(keyname + '.pub') as pub_key:
    with open('~/.ssh/authorized_keys', 'a') as auth_keys:
      auth_keys.write(pub_key.read())
  with open(keyname) as keyfile:
    priv_key = keyfile.readall()
  os.remove(keyname)
  return priv_key
  
