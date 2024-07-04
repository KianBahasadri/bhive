import json

with open("server_data.json") as file:
  bhive_data = json.loads(file.readall())

for server in bhive_data['servers']:
  
  

