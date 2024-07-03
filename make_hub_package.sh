#!/bin/bash

tar -czf hub_package.tar.gz \
  -C hub \
    add_server.py \
    bhive_data.json \
    find_ssh_port.sh \
    rebuild_nginx_conf.py \
    requirements.py \

  -C ../initialization \
    hub_initialize.sh \

  -C ../keys \
    bahasadri.com.crt \
    bahasadri.com.key \

echo
echo hub_package.tar.gz has been created

