source common.sh

echo -e "\e[32minstall nodejs\e[0m"
dnf module disable nodejs -y &>>${log}
dnf module enable nodejs:18 -y &>>${log}
dnf install nodejs -y &>>${log}
status_check

echo -e "\e[32madd user\e[0m"
useradd roboshop &>>${log}
status_check


echo -e "\e[32mcreating appliction file\e[0m"
mkdir -p /app &>>${log}
status_check


echo -e "\e[32installing catalogue file content\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log}
status_check


echo -e "\e[32mrmoving old app content\e[0m"
rm -rf /app/* &>>${log}
status_check


echo -e "\e[32munziping content\e[0m"
cd /app &>>${log}
unzip /tmp/catalogue.zip &>>${log}
status_check


echo -e "\e[32minstall nodejs dependencies\e[0m"
npm install &>>${log}
status_check


echo -e "\e[32msetting up catalogue service file\e[0m"
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${log}
status_check


echo -e "\e[32minstalling,enabling and starting catalogue\e[0m"
systemctl daemon-reload &>>${log}
systemctl start catalogue &>>${log}
systemctl enable catalogue &>>${log}
status_check


echo -e "\e[32mload schema\e[0m"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log}
yum install mongodb-org-shell -y &>>${log}
mongo --host mongodb-dev.devops01.online </app/schema/catalogue.js &>>${log}
status_check


