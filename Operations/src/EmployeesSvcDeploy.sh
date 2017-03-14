#!/bin/bash
cloud_domain=$1
cloud_zone=$2

if [[ $cloud_zone == em* ]]; then
  cloud_zone="europe";
else
    if [[ $cloud_zone == us* ]]; then
        cloud_zone="us";
    fi
fi

cloud_paas_rest_url=https://apaas.$cloud_zone.oraclecloud.com

echo "Connecting to $cloud_paas_rest_url"

#export cloud_username=$(curl -s -X GET -H 'X-Oracle-Authorization: Basic Z3NlLWRldm9wc193d0BvcmFjbGUuY29tOjVjWmJzWkxuMQ==' 'https://adsweb.oracleads.com/apex/adsweb/parameters/democloud_admin_opc_email' | jq '.items[].value' | tr -d '"')
#export cloud_password=$(curl -s -X GET -H 'X-Oracle-Authorization: Basic Z3NlLWRldm9wc193d0BvcmFjbGUuY29tOjVjWmJzWkxuMQ==' 'https://adsweb.oracleads.com/apex/adsweb/parameters/democloud_admin_opc_password' | jq '.items[].value' | tr -d '"')

cloud_username=$3
cloud_password=$4

echo "Printing GSE Credentials"
echo "$cloud_username - $cloud_password"

cat <<EOF >Employees/deployment.json
{
    "memory": "2G",
    "instances": "1",
    "services": [{
        "identifier": "MySQLService",
        "type": "MYSQLCS",
        "name": "EmployeeMySQL",
        "username": "root",
        "password": "Welc0me_2017"
    }]
}
EOF

echo "Starting the deployment process...."

echo "Creating a storage container..."
curl -i -X PUT \
  -u ${cloud_username}:${cloud_password} \
  https://${cloud_domain}.storage.oraclecloud.com/v1/Storage-${cloud_domain}/cloudnative-service
sleep 15

echo "Uploading the ZIP file in Storage Container..."
curl -i -X PUT \
    -u ${cloud_username}:${cloud_password} \
    https://${cloud_domain}.storage.oraclecloud.com/v1/Storage-${cloud_domain}/cloudnative-service/EmployeesService.zip \
    -T Employees/target/Employees-dist.zip
sleep 15

# See if application already exists
let httpCode=`curl -i -X GET  \
  -u ${cloud_username}:${cloud_password} \
  -H "X-ID-TENANT-NAME:${cloud_domain}" \
  -H "Content-Type: multipart/form-data" \
  -sL -w "%{http_code}" \
  ${cloud_paas_rest_url}/paas/service/apaas/api/v1.1/apps/${cloud_domain}/EmployeesService \
  -o /dev/null`

# If application exists...
if [ ${httpCode} -eq 200 ]
then
  # Update application
    echo '\n[info] Updating application...\n'
    curl -i -X PUT  \
        -u ${cloud_username}:${cloud_password} \
        -H "X-ID-TENANT-NAME:${cloud_domain}" \
        -H "Content-Type: multipart/form-data" \
        -F archiveURL=cloudnative-service/EmployeesService.zip \
        ${cloud_paas_rest_url}/paas/service/apaas/api/v1.1/apps/${cloud_domain}/EmployeesService
	sleep 60
else
    echo "Deploying the application to ACCS..."
    curl -X POST -u ${cloud_username}:${cloud_password} \
        -H "X-ID-TENANT-NAME:${cloud_domain}" \
        -H "Content-Type: multipart/form-data" \
        -F "name=EmployeesService" -F "runtime=java" -F "subscription=Monthly" \
        -F "deployment=@Employees/deployment.json" \
        -F "archiveURL=cloudnative-service/EmployeesService.zip" -F "notes=Employees Service deploying..."  \
        ${cloud_paas_rest_url}/paas/service/apaas/api/v1.1/apps/${cloud_domain}
	sleep 60
fi

echo "Deployment successfully completed!"
