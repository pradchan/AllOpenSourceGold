#!/bin/bash

echo "Starting Employees-DB..."
docker run --name employees-db -d \
    -e MYSQL_ROOT_PASSWORD=welcome1 \
    -e MYSQL_DATABASE=hr -e MYSQL_USER=hr_user \
    -e MYSQL_PASSWORD=welcome1 -p 3307:3306 mysql:latest

docker exec employees-db sleep 60

echo "Waiting for DB to start up..."
docker exec employees-db mysqladmin --silent --wait=10 -uhr_user -pwelcome1 ping || exit 1

echo "Setting up sample data..."
docker exec -i employees-db mysql -uhr_user -pwelcome1 hr < employees.sql
