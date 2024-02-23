source common.sh

print_head "configuring yum repos"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

print_head "enable redis remi"
dnf module enable redis:remi-6.2 -y

print_head "install redis"
yum install redis -y

print_head "modifying redis.conf"
sed -i -e "/127.0.0.1/0.0.0.0/" /etc/redis.conf

print_head "enable redis"
systemctl enable redis

print_head "start redis"
systemctl start redis

