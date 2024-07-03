#!/bin/bash

tar -czf hub_package.tar.gz \
  -C hub \
    add_server.py \
    bhive_data.json \
    find_ssh_port.sh \
    rebuild_nginx_conf.py \

  -C ../initialization \
    hub_initialize.sh

echo hub_package.tar.gz has been created

