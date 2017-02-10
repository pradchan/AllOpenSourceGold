#!/bin/bash
cloud_domain=$1
ACCS_DATACENTER=$2

sed -i 's/IDENTITY_DOMAIN/'$cloud_domain'/' Employees/src/main/resources/public/index.html
sed -i 's/DATACENTER/'$ACCS_DATACENTER'/' Employees/src/main/resources/public/index.html
