source common.sh

if [ -z "${mysql_pass}" ]; then
	echo "mysql pass is missing"
fi

print_head "disable mysql old version"
dnf module disable mysql -y
status_check

print_head "copying mysql repo"
cp ${script_location}/files/mysql.repo /etc/yum.repos.d/mysql.repo
status_check

print_head "copying mysql repo"
dnf install mysql-community-server -y
status_check

print_head "copying mysql repo"
systemctl enable mysql
status_check


print_head "copying mysql repo"
systemctl start mysql
status_check

print_head "copying mysql repo"
mysql_secure_installation --set-root-pass ${mysql_pass}
status_check





