#!/bin/bash
yum install nginx -y
systemctl start nginx
systemctl enable nginx


cd /usr/share/nginx/html/*
rm -rf *
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip 
unzip /tmp/frontenc.zip

cp /files/nginx.roboshop.conf /etc/nginx/default.d/roboshop.conf

systemctl restart nginx
