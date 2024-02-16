#!/bin/bash
script_location=$(pwd)

yum install nginx -y
systemctl enable nginx
systemctl start nginx


cd /usr/share/nginx/html
rm -rf *
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip 
unzip /tmp/frontend.zip
# note : we are switching the location to /usr/share/nginx/html. from this location it looks for the file so we need to comeback again

cp $script_location/files/nginx/roboshop.conf /etc/nginx/default.d/roboshop.conf

systemctl restart nginx
