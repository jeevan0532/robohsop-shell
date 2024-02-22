#!/bin/bash
script_location=$(pwd)
log=/tmp/roboshop.log

echo -e "\e[35minstall nginx\e[0m"
yum install nginx -y &>> ${log}

echo -e "\e[35mremove old content\e[0m"
rm -rf /usr/share/nginx/html/* &>> ${log}

echo -e "\e[35minstall forntend content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>> ${log}


echo -e "\e[35munzip frontend content\e[0m"
cd /usr/share/nginx/html &>> ${log}
unzip /tmp/frontend.zip &>> ${log}

# note : we are switching the location to /usr/share/nginx/html. from this location it looks for the file so we need to comeback again
echo -e "\e[35mseting up nginx op conf file\e[0m"
cp $script_location/files/nginx.roboshop.conf /etc/nginx/default.d/roboshop.conf &>> ${log}

echo -e "\e[35menable nginx\e[0m"
systemctl enable nginx &>> ${log}

echo -e "\e[35mstart nginx\e[0m"
systemctl restart nginx &>> ${log}

