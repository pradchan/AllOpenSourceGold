#!/bin/bash
sudo chown oracle:oracle /tmp/create-user-mysqlcs.*
sudo chmod 777 /tmp/create-user-mysqlcs.*
sudo su - oracle -c 'mysql EmployeeMySQLDB </tmp/create-user-mysqlcs.sql'
exit
