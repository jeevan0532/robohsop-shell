script_location=$(pwd)
log=/tmp/roboshop.log

echo -e "\e[32minstall nodejs\e[0m"
dnf module disable nodejs -y &>>${log}
dnf module enable nodejs:18 -y &>>${log}
dnf install nodejs -y &>>${log}

echo $?
if [ $? -eq 0 ]; then
	echo -e "\e[34m SUCCESS \e[0m"
else
	echo -e "\e[32m FAILURE \e[0m"
fi

echo -e "\e[32madd user\e[0m"
useradd roboshop &>>${log}
echo $?
if [ $? -eq 0 ]; then
        echo -e "\e[34m SUCCESS \e[0m"
else
        echo -e "\e[32m FAILURE \e[0m"
fi

echo -e "\e[32mcreating appliction file\e[0m"
mkdir -p /app &>>${log}
echo $?
if [ $? -eq 0 ]; then
        echo -e "\e[34m SUCCESS \e[0m"
else
        echo -e "\e[32m FAILURE \e[0m"
fi

echo -e "\e[32installing catalogue file content\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log}
echo $?
if [ $? -eq 0 ]; then
        echo -e "\e[34m SUCCESS \e[0m"
else
        echo -e "\e[32m FAILURE \e[0m"
fi


echo -e "\e[32mrmoving old app content\e[0m"
rm -rf /app/* &>>${log}
echo $?
if [ $? -eq 0 ]; then
        echo -e "\e[34m SUCCESS \e[0m"
else
        echo -e "\e[32m FAILURE \e[0m"
fi


echo -e "\e[32munziping content\e[0m"

cd /app &>>${log}
echo $?
if [ $? -eq 0 ]; then
        echo -e "\e[34m SUCCESS \e[0m"
else
        echo -e "\e[32m FAILURE \e[0m"
fi

unzip /tmp/catalogue.zip &>>${log}
echo $?
if [ $? -eq 0 ]; then
        echo -e "\e[34m SUCCESS \e[0m"
else
        echo -e "\e[32m FAILURE \e[0m"
fi


echo -e "\e[32minstall nodejs dependencies\e[0m"

npm install &>>${log}
echo $?
if [ $? -eq 0 ]; then
        echo -e "\e[34m SUCCESS \e[0m"
else
        echo -e "\e[32m FAILURE \e[0m"
fi


echo -e "\e[32msetting up catalogue service file\e[0m"

cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${log}
echo $?
if [ $? -eq 0 ]; then
        echo -e "\e[34m SUCCESS \e[0m"
else
        echo -e "\e[32m FAILURE \e[0m"
fi

echo -e "\e[32minstalling,enabling and starting catalogue\e[0m"

systemctl daemon-reload &>>${log}
echo $?
if [ $? -eq 0 ]; then
        echo -e "\e[34m SUCCESS \e[0m"
else
        echo -e "\e[32m FAILURE \e[0m"
fi

systemctl start catalogue &>>${log}
echo $?
if [ $? -eq 0 ]; then
        echo -e "\e[34m SUCCESS \e[0m"
else
        echo -e "\e[32m FAILURE \e[0m"
fi

systemctl enable catalogue &>>${log}
echo $?
if [ $? -eq 0 ]; then
        echo -e "\e[34m SUCCESS \e[0m"
else
        echo -e "\e[32m FAILURE \e[0m"
fi


echo -e "\e[32mload schema\e[0m"

cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log}
echo $?
if [ $? -eq 0 ]; then
        echo -e "\e[34m SUCCESS \e[0m"
else
        echo -e "\e[32m FAILURE \e[0m"
fi

yum install mongodb-org-shell -y &>>${log}
echo $?
if [ $? -eq 0 ]; then
        echo -e "\e[34m SUCCESS \e[0m"
else
        echo -e "\e[32m FAILURE \e[0m"
fi

mongo --host mongodb-dev.devops01.online </app/schema/catalogue.js &>>${log}
echo $?
if [ $? -eq 0 ]; then
        echo -e "\e[34m SUCCESS \e[0m"
else
        echo -e "\e[32m FAILURE \e[0m"
fi

