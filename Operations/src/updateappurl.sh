#!/bin/bash
config_file="Operations/src/config.properties"
while IFS='=' read -r key value
do
  key=$(echo $key | tr '.' '_')
  eval "${key}='${value}'"
done < "$config_file"

sed -i 's/IDENTITY_DOMAIN/'$cloud_domain'/' EmployeesClient/index.html
sed -i 's/DATACENTER/'$ACCS_DATACENTER'/' EmployeesClient/index.html
