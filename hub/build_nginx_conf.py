import json
import nginxparser_eb

with open("build/bhive_data.json") as file:
  bhive_data = json.loads(file.read())

with open("nginx_default_conf.txt") as file:
  nginx_conf = nginxparser_eb.load(file)

for block in nginx_conf:
  if block[0] == ['server']:
    for block2 in block[1]:
      if type(block2[0]) == list and block2[0][0] == 'location': 
        location_list = block2


location_list.append(["# AUTO-GENERATED CONFIG BELOW"])

for service in bhive_data['services'].items():
  name = service['name']
  port = service['port']
  location_list.append(['location', f"/{name}"])
  location_list.append([['proxy_pass', f"http://127.0.0.1:{port}"]])

with open("build/bhive_data.json", 'w') as file:
  file.write(nginxparser_eb.dumps(nginx_conf))
  file.truncate()

# This is what nginx_conf looks like when first read
"""
[
    ['ssl_session_cache', 'shared:SSL:10m'],
    ['ssl_session_timeout', '10m'],
    [
        ['server'],
        [
            ['listen', '443 ssl'],
            ['server_name', 'bahasadri.com'],
            ['ssl_certificate', '/etc/nginx/ssl/bahasadri.com.crt'],
            ['ssl_certificate_key', '/etc/nginx/ssl/bahasadri.com.key'],
            [
                ['location', '/add-server'],
                [
                    ['proxy_pass', 'http://127.0.0.1:8001']
                ]
            ],
            [
                ['location', '/'],
                [
                    ['index', '/etc/nginx/html/home.html']
                ]
            ]
        ]
    ]
]
"""
