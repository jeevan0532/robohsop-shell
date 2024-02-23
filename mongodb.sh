source common.sh

print_head "copying mongodb repo file"
cp ${script_location}/app/mongodb.repo  /etc/yum.repos.d/mongo.repo
status_check

print_head "installing mongodb"
yum install mongodb-org -y
status_check

print_head "enable mongod"
systemctl enable mongod
status_check

print_head "start mongod"
systemctl start mongod
status_check

print_head "edit mongod.conf file"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
status_check

print_head "restart mongod"
systemctl restart mongod
status_check
