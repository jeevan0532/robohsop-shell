script_location=$(pwd)

echo -e "\e[32minstall nodejs\e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y

echo -e "\e[32madd user\e[0m"

useradd roboshop
echo -e "\e[32mcreating appliction file\e[0m"

mkdir -p /app

echo -e "\e[32installing catalogue file content\e[0m"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

echo -e "\e[32mrmoving old app content\e[0m"

rm -rf /app/*

echo -e "\e[32munziping content\e[0m"

cd /app
unzip /tmp/catalogue.zip

echo -e "\e[32minstall nodejs dependencies\e[0m"

npm install

echo -e "\e[32msetting up catalogue service file\e[0m"

cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[32minstalling,enabling and starting catalogue\e[0m"

systemctl daemon-reload
systemctl start catalogue
systemctl enable catalogue

echo -e "\e[32mload schema\e[0m"

cp ${script_location}/tmp/mongodb.repo /etc/yum.repos.d/mongodb.repo
yum install mongodb-org-shell -y
mongo --host mongodb-dev.devops01.online </app/schema/catalogue.js
