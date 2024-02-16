#!/bin/bash
script_location=$(pwd)

yum install nginx -y
systemctl enable nginx
systemctl start nginx


rm -rf /usr/share/nginx/html/*
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
# note : we are switching the location to /usr/share/nginx/html. from this location it looks for the file so we need to comeback again

cp $script_location/files/nginx/roboshop.conf /etc/nginx/default.d/roboshop.conf

systemctl restart nginx
