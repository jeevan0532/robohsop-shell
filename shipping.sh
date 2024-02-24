source common.sh

if [ -z "${mysql_pass}" ]; then
	echo "mysql password is missing"
	exit
fi



component=shipping
schema_load=true
schema_type=mysql
maven
