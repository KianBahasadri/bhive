import json
import nginxfmt

with open("server_data.json") as file:
  data = json.loads(file.readall())

for server in data:


