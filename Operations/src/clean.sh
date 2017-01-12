#!/bin/bash

config_file="Operations/src/config.properties"
while IFS='=' read -r key value
do
  key=$(echo $key | tr '.' '_')
  eval "${key}='${value}'"
done < "$config_file"

instance=`python Operations/src/Instance_Name.py ${cloud_username} ${cloud_password} ${cloud_domain} ${compute_rest_url} ${compute_instance_prefix}`

if [ ${#instance} -gt 0 ]; then
    echo "Compute VM already exists...Deleting Docker containers..."
    #bash Operations/src/delete-containers.sh
    bash Operations/src/delete-instance.sh
else
    echo "Compute VM does not exists...No cleaning required..."
fi
