#!/bin/bash

tar -czf server_package.tar.gz \
  -C ../initialization \
    server_initialize.sh

echo server_package.tar.gz has been created

