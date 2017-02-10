#!/bin/bash
##
if [ $# -lt 1 ]
then
    echo "Usage: $0 <DBCS IP>"
    exit 1
fi
DB_IP=$1


export BASE="Operations/src";

#
echo "************************************************"
echo "* Copy over needed files to MyDBCS image ...."
echo "************************************************"
scp -o "StrictHostKeyChecking no" -i ${BASE}/labkey ${BASE}/create-user-mysql*.* opc@${DB_IP}:/tmp/.
#
echo "********************************************"
echo "* Create hr_user (password = welcome1) ...."
echo "********************************************"
ssh -o "StrictHostKeyChecking no" -i ${BASE}/labkey opc@${DB_IP} "/tmp/create-user-mysqlcs.sh"
#
echo "***************************************************"
echo "* SmartBundles Database setup is Complete ...."
echo "***************************************************"

exit 0;
