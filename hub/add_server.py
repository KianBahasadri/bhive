from fastapi import FastAPI, Request
from fastapi.responses import PlainTextResponse
from pydantic import BaseModel
import json
import subprocess
import os

class Diagnostic(BaseModel):
  cores: int
  ram: float
  free_space: float
  total_space: float

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

@app.post("/add-server", response_class=PlainTextResponse)
async def add_server(diagnostic: Diagnostic, request: Request):
  # Part 1: add server to bhive_data.json
    # Preparing Data
  new_server = template_server.copy()
  new_server['resources'] = diagnostic.dict()
  ip = request.client.host

  ssh_output = subprocess.run(['./find_ssh_port.sh', ip], capture_output=True, Text=True)
  new_server['sshport'] = ssh_output.stdout.strip()

    # Adding Data
  with open('bhive_data.json', 'rw') as bhive_file:
    bhive_str = bhive_file.read()
    bhive_json = json.loads(bhive_str)
    bhive_json['servers'].append[new_server]
    bhive_file.seek(0)
    bhive_file.write(json.dumps(bhive_json))
    bhive_file.truncate()

  # Part 2: generate keyfile and return it
  keyname = ip.replace('.', '_') + '_ssh_key.pem'
  subprocess.run(['ssh-keygen', '-f', keyname, '-N', ''])

  with open(keyname + '.pub') as pub_key:
    with open(os.path.expanduser('~/.ssh/authorized_keys'), 'a') as auth_keys:
      auth_keys.write(pub_key.read())
  with open(keyname) as keyfile:
    priv_key = keyfile.read()
  os.remove(keyname)
  return priv_key
  
