#!/bin/bash

config_file="Operations/src/config.properties"
while IFS='=' read -r key value
do
  key=$(echo $key | tr '.' '_')
  eval "${key}='${value}'"
done < "$config_file"

instance=`python Operations/src/Instance_Name.py ${cloud_username} ${cloud_password} ${cloud_domain} ${compute_rest_url} ${compute_instance_prefix}`

echo 'Deleted all Docker containers!!!'
if [ ${#instance} -gt 0 ]; then
    echo "Compute VM already exists...Cleaning..."
	# Delete all docker container and keep the compute instance clean
	#ip=`python Operations/src/Public_IP.py ${cloud_username} ${cloud_password} ${cloud_domain} ${compute_rest_url} ${compute_instance_prefix}`
	#ssh -i Operations/src/cloudnative -tt -o StrictHostKeyChecking=no opc@${ip} < Operations/src/docker-clean.sh
	
	# Delete the compute instance
    python Operations/src/DeleteInstance.py ${cloud_username} ${cloud_password} ${cloud_domain} ${compute_rest_url} ${compute_instance_prefix}
else
    echo "Compute VM does not exists...No cleaning required..."
fi
