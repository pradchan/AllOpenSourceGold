#!/bin/bash

config_file="PythonScripts/src/config.properties"
while IFS='=' read -r key value
do
  key=$(echo $key | tr '.' '_')
  eval "${key}='${value}'"
done < "$config_file"

ip=`python Operations/src/Public_IP.py ${cloud_username} ${cloud_password} ${cloud_domain} ${compute_rest_url} ${compute_instance_prefix}`

# Delete all docker container and keep the compute instance clean
ssh -i Operations/src/cloudnative -tt -o StrictHostKeyChecking=no opc@${ip} < Operations/src/docker-clean.sh

echo 'Deleted all Docker containers!!!'