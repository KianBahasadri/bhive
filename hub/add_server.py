from fastapi import FastAPI, Request, BackgroundTasks
from fastapi.responses import PlainTextResponse
from pydantic import BaseModel
import json
import subprocess
import os
import time

class Diagnostic(BaseModel):
  cores: int
  ram: float
  free_space: float
  total_space: float

template_server = {
  "service ids": [],
  "sshport": 0,
  "resources": {
    "cores": 0,
    "ram": 0,
    "free space": 0,
    "total space": 0
  }
}

app = FastAPI()

@app.post("/add-server", response_class=PlainTextResponse)
async def add_server(diagnostic: Diagnostic, request: Request):
  # Part 1: generate keyfile and return it
  ip = request.client.host
  keyname = ip.replace('.', '_') + '_ssh_key'
  subprocess.run(['ssh-keygen', '-f', keyname, '-N', ''])

  with open(keyname + '.pub') as pub_key:
    with open(os.path.expanduser('~/.ssh/authorized_keys'), 'a') as auth_keys:
      auth_keys.write(pub_key.read())
  with open(keyname) as keyfile:
    priv_key = keyfile.read()
  os.remove(keyname)
  
  # Key gets returned -> ssh connection opens -> bckgtsk runs
  background_tasks.add_task(update_bhive_data, diagnostic)

  return priv_key

def update_bhive_data(diagnostic: Diagnostic):
  time.sleep(5) # Wait for SSH connection to be established by client
  ssh_output = subprocess.run(['./find_ssh_port.sh', ip], capture_output=True, Text=True)
  if not ssh_output:
    print("First ./find_ssh_port.sh did not find anything, waiting 5 seconds and trying again")
    time.sleep(5)
    ssh_output = subprocess.run(['./find_ssh_port.sh', ip], capture_output=True, Text=True)

  # Part 2: add server to bhive_data.json
  # Preparing Data as new_server
  new_server = template_server.copy()
  new_server['resources'] = diagnostic.dict()
  new_server['sshport'] = ssh_output.stdout.strip()

  # Adding Data to file
  with open('bhive_data.json', 'rw') as bhive_file:
    bhive_str = bhive_file.read()
    bhive_json = json.loads(bhive_str)
    bhive_json['servers'].append[new_server]
    bhive_file.seek(0)
    bhive_file.write(json.dumps(bhive_json))
    bhive_file.truncate()

