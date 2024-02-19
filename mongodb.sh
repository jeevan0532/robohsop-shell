#!/bin/bash

script_location=$(pwd)
cp $script_location/files/mongodb.repo /etc/yum.repos.d/mongodb.repo

yum install mongodb-org -y
systemctl enable mongod
systemctl start mongod

pwd 
ls

exit 

# edit file in mongod.conf

sed -e -i 's/127.0.0.1/0.0.0.0' /etc/mongod.conf

systemctl restart mongod
