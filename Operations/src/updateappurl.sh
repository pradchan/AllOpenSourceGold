#!/bin/bash
cloud_domain=$1
ACCS_DATACENTER=$2

ms_url="https://employeesservice-${cloud_domain}.apaas.${ACCS_DATACENTER}.oraclecloud.com/api/"
sed -i 's#MICROSERVICE_URL#'${ms_url}'#' Employees/src/main/resources/public/index.html
