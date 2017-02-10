#!/bin/bash

usage () {
	echo "Usage: `dirpath $0`/`basename $0` <Identity_Domain> <DataCenter (europe/us)>";
	exit 1;
}

if [ $# -ne 2 ]; then 
	usage;
fi

export BASE="Operations/src";

export cloud_username=$(curl -s -X GET -H 'X-Oracle-Authorization: Basic Z3NlLWRldm9wc193d0BvcmFjbGUuY29tOjVjWmJzWkxuMQ==' 'https://adsweb.oracleads.com/apex/adsweb/parameters/democloud_admin_opc_email' | jq '.items[].value' | tr -d '"')
export cloud_password=$(curl -s -X GET -H 'X-Oracle-Authorization: Basic Z3NlLWRldm9wc193d0BvcmFjbGUuY29tOjVjWmJzWkxuMQ==' 'https://adsweb.oracleads.com/apex/adsweb/parameters/democloud_admin_opc_password' | jq '.items[].value' | tr -d '"')

echo "Printing GSE Credentials"
echo "$cloud_username - $cloud_password"

#cloud_username=cloud.admin
#cloud_password=sInfUl@7Harm

cloud_domain=$1
DC="us";

if [ "$2x" -eq "em2x" ]; then
  $DC="europe";
fi

cloud_paas_rest_url=apaas.${DC}.oraclecloud.com;
DBAAS_NAME=EmployeeMySQL
DBAAS_USER_NAME=hr_user
DBAAS_USER_PASSWORD=welcome1
DBAAS_ADMIN_PASSWORD=Welc0me_2017


if [ ${DC} != "europe" ]; then
	sed -i 's/psm.europe.oraclecloud.com/psm.us.oraclecloud.com/g' ${BASE}/opc-mysqlcs-ws.ref
fi

dbviewoutput=`python ${BASE}/opc-mysqlcs.py -i ${cloud_domain} -u ${cloud_username} -p ${cloud_password} -o VIEW -l ${BASE}/opc_mysqlcs_view.log -w ${BASE}/opc-mysqlcs-ws.ref -n ${DBAAS_NAME}`

if test "${dbviewoutput#*$DBAAS_NAME}" != "$dbviewoutput"
    then
        # $DBAAS_NAME is in $dbviewoutput
		json_string=`cat opc_mysqlcs_view.log | grep -o "{.*" > state_json.json`
		current_state=`python readCurrentStatus.py`
		rm ${BASE}/opc_mysqlcs_view.log

		if [ "$current_state" == "READY" ]
			then
				echo "Database ${DBAAS_NAME} already exists."
				echo "Schema would be refreshed.."
			else
				echo "Database ${DBAAS_NAME} is already initialized."
				echo "Try the status after sometime."
				exit;
		fi
    else
        # $DBAAS_NAME is not in $dbviewoutput
		echo "Database ${DBAAS_NAME} does not exists. Creating new instance..."
		publickey=`cat ${BASE}/labkey.pub`
		
		sed -i 's/IDENTITY_DOMAIN/'$cloud_domain'/' ${BASE}/create-mysqlcs-img.json
		sed -i 's/CLOUD_USER/'$cloud_username'/' ${BASE}/create-mysqlcs-img.json
		sed -i 's/CLOUD_PASSWORD/'$cloud_password'/' ${BASE}/create-mysqlcs-img.json
		sed -i 's/DBAAS_ADMIN_PASSWORD/'$DBAAS_ADMIN_PASSWORD'/' ${BASE}/create-mysqlcs-img.json
		
		python ${BASE}/opc-mysqlcs.py -i ${cloud_domain} -u ${cloud_username} -p ${cloud_password} -o BUILD -w ${BASE}/opc-mysqlcs-ws.ref -l ${BASE}/opc_mysqlcs.log -d ${BASE}/create-mysqlcs-img.json
fi

python ${BASE}/opc-mysqlcs.py -i ${cloud_domain} -u ${cloud_username} -p ${cloud_password} -o VIEW -w ${BASE}/opc-mysqlcs-ws.ref -l ${BASE}/opc_mysqlcs_view.log -n ${DBAAS_NAME}

json_string=`cat ${BASE}/opc_mysqlcs_view.log | grep -o "{.*" > ${BASE}/ip_json.json`

mysqlcs_public_ip=`python ${BASE}/readIpAddress.py | cut -d: -f1 | sed -e 's/",//g' | sed -e 's/"//g'`

if [ ${#mysqlcs_public_ip} -gt 0 ]; then
	echo "Have valid Public IP ${mysqlcs_public_ip}."
	
	while (true); do exec 3>/dev/tcp/${mysqlcs_public_ip}/22; if [ $? -eq 0 ]; then echo "SSH up..." ; break ; else echo "SSH still down..." ; sleep 3 ; fi done
	
	ssh -i ${BASE}/labkey -o StrictHostKeyChecking=no opc@${mysqlcs_public_ip} "sudo rm /tmp/create-user-mysqlcs.*; exit;"
	#scp -i ${BASE}/labkey -o StrictHostKeyChecking=no -r ${BASE}/create-user-mysqlcs.*  opc@${mysqlcs_public_ip}:/tmp
	#ssh -i ${BASE}/labkey -tt -o StrictHostKeyChecking=no opc@${mysqlcs_public_ip} "cd /tmp; ./create-user-mysqlcs.sh; exit;"
        ${BASE}/runSBMySQLDBSetup.sh ${mysqlcs_public_ip};
else
	echo "Public IP is not valid."
fi


