source common.sh
i
print_head "configuring yum repos" &>>{log}

yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

print_head "enable redis remi" &>>{log}

dnf module enable redis:remi-6.2 -y

print_head "install redis" &>>{log}

yum install redis -y

print_head "modifying redis.conf" &>>{log}

sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf

print_head "enable redis" &>>{log}

systemctl enable redis

print_head "start redis" &>>{log}
systemctl start redis

