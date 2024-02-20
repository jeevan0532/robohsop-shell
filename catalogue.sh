script_location=$(pwd)

dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y

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

cp ${script_location}/tmp/mongodb.repo /etc/yum.repos.d/mongodb.repo
yum install mongodb-org-shell -y
mongo --host localhost </app/schema/catalogue.js
