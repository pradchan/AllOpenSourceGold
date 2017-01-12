#!/bin/bash

# This script demonstrates end to end automated process of creating
# an Oracle Compute Cloud instance and setting up Docker platform
# on the new created Oracle Compute Cloud instance

config_file="Operations/src/config.properties"
while IFS='=' read -r key value
do
  key=$(echo $key | tr '.' '_')
  eval "${key}='${value}'"
done < "$config_file"

instance=`python Operations/src/Instance_Name.py ${cloud_username} ${cloud_password} ${cloud_domain} ${compute_rest_url} ${compute_instance_prefix}`

if [ ${#instance} -gt 0 ]; then
    echo "Compute VM already exists..."  
    # Read the IP address of Compute from hosts file
    ip=`python Operations/src/Public_IP.py ${cloud_username} ${cloud_password} ${cloud_domain} ${compute_rest_url} ${compute_instance_prefix}`
else
python Operations/src/CreateComputeCloudInstance.py ${cloud_username} ${cloud_password} ${cloud_domain} ${compute_rest_url} ${compute_instance_prefix}
    echo "Sleep for 60 seconds for the SSH port of the Compute instance to be accessible"
    sleep 60

    # Read the IP address of Compute from hosts file
    ip=`python Operations/src/Public_IP.py ${cloud_username} ${cloud_password} ${cloud_domain} ${compute_rest_url} ${compute_instance_prefix}`

    while (true)  
    do
    	ssh -i PythonScripts/src/cloudnative -tt -o StrictHostKeyChecking=no opc@${ip} "exit;"
    	case $? in
        	(0) echo "Successfully connected."; break ;;
        	(*) echo "SSH Port not ready yet, waiting 30 seconds..." ;;
    	esac
    	sleep 30
    done

	#while (true); do exec 3>/dev/tcp/${ip}/22; if [ $? -eq 0 ]; then echo "SSH up" ; break ; else echo "SSH still down" ; sleep 60 ; fi done
                        
	# Connect to Compute instance and prepare ground for Docker installation
    ssh -i Operations/src/cloudnative -tt -o StrictHostKeyChecking=no opc@${ip} < Operations/src/docker-pre-conf.sh
    echo "Sleep for 90 seconds while the Compute instance restarts"
    sleep 90
    # Ensure the compute is up and running after restart
    echo "Attempting to SSH to Compute..."  

	while (true); do exec 3>/dev/tcp/${ip}/22; if [ $? -eq 0 ]; then echo "SSH up" ; break ; else echo "SSH still down" ; sleep 60 ; fi done

    # Install Docker platform
    ssh -i Operations/src/cloudnative -tt -o StrictHostKeyChecking=no opc@${ip} < Operations/src/docker-post-conf.sh
    ssh -i Operations/src/cloudnative -tt -o StrictHostKeyChecking=no opc@${ip} "sleep 30; sudo service docker start; sleep 120; sudo service docker restart; exit;"
fi

sleep 30

if [ -d "Employees/employees-database" ]; then
    # Initialize and Start a new Docker container for Employees-Database
    scp -i Operations/src/cloudnative -o StrictHostKeyChecking=no -r Employees/employees-database opc@${ip}:/tmp
    ssh -i Operations/src/cloudnative -tt -o StrictHostKeyChecking=no opc@${ip} "cd /tmp/employees-database; chmod +x start.sh; ./start.sh; exit;"
fi
sleep 5
