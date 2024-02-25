source common.sh

if [ -z "${rabbitmq_pass}" ]; then
	echo "rabbitmq pass is missing"
fi

print_head "yum repos for erlang"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$log
status_check

print_head "yum repos for rabbitmq"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$log
status_check


print_head "install rabbitmq & erlang"
yum install rabbitmq-server erlang -y  &>>$log

status_check


print_head "enable and start"
systemctl enable rabbitmq-server  &>>$log

systemctl start rabbitmq-server  &>>$log

status_check


print_head "add user and password"
rabbitmqctl list_users | grep roboshop &>>$log

if [ $? -ne 0 ]; then
 rabbitmqctl add_user roboshop ${rabbitmq_pass}
fi
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>>$log

status_check

