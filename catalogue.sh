#!/bin/bash

script_location=$(pwd)

curl -sL https://rpm.nodesource.com/setup_ltx |  bash 
yum install nodejs -y

useradd roboshop
mkdir -p /app

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
rm -rf /app/*

cd /app
unzip /tmp/catalogue.zip
npm install

cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service
systemctl deamon-reload
systemctl start catalogue
systemctl enable catalogue
