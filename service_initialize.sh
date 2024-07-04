#!/bin/bash

if [[ $# != 1 ]]
then
  echo "Usage: ./service_initialize.sh <some file>"
fi


echo
echo determine the resource usage of this service

echo
echo search in bhive_data.json for appropriate server to run this on

echo
echo copy something to the selected server

echo
echo start the service on the server

echo
echo add endpoint to the bhive_data.json

echo
echo rebuild nginx config file

echo
echo This service has now been added to the BHive
echo WELCOME ABOARD! 🥳🥳🥳
