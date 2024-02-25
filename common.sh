#!/bin/bash
script_location=$(pwd)
log=/tmp/roboshop.log

status_check() {
 if [ $? -eq 0 ]; then
        echo -e "\e[32msuccess\e[0m"
 else
        echo -e "\e[33mfailure\e[0m"
        echo "failure, refer to the log-${log}"
        exit
 fi
}


print_head() {
echo -e "\e[1m $1 \e[0m"
}


schema_load() {
  if [ ${schema_load} == "true" ]; then
	  if [ ${chema_type} == "mongo" ]; then
  echo -e "\e[32mload schema\e[0m"
  cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log}
  yum install mongodb-org-shell -y &>>${log}
  mongo --host mongodb-dev.devops01.online < /app/schema/${component}.js &>>${log}
  status_check
	  fi

	  if [ ${schema_type} == "mysql" ]; then
            echo -e "\e[32mload schema\e[0m"
            yum install mysql -y &>>${log}
            mysql -h mysql-dev.devops01.online -uroot -p${mysql_pass} < /app/schema/${component}.sql &>>${log}
            status_check
           fi

 fi

}


app_prereq(){
  echo -e "\e[32madd user\e[0m"
 id roboshop
 if [ $? -ne 0 ]; then
  useradd roboshop &>>${log}
 fi
 status_check

 echo -e "\e[32mcreating appliction file\e[0m"
 mkdir -p /app &>>${log}
 status_check


 echo -e "\e[32installing catalogue file content\e[0m"
 curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
  status_check


 echo -e "\e[32mrmoving old app content\e[0m"
 rm -rf /app/* &>>${log}
 status_check


 echo -e "\e[32munziping content\e[0m"
 cd /app &>>${log}
 unzip /tmp/${component}.zip &>>${log}
 status_check


}

systemd_setup() {
	echo -e "\e[32msetting up $component service file\e[0m"
 cp ${script_location}/files/${component}.service /etc/systemd/system/${component}.service &>>${log}
 status_check


 echo -e "\e[32minstalling,enabling and starting catalogue\e[0m"
 systemctl daemon-reload &>>${log}
 systemctl start ${component} &>>${log}
 systemctl enable ${component} &>>${log}
 status_check

}

nodejs(){
	echo -e "\e[32minstall nodejs\e[0m"
 dnf module disable nodejs -y &>>${log}
 dnf module enable nodejs:18 -y &>>${log}
 dnf install nodejs -y &>>${log}
 status_check

 app_prereq

 echo -e "\e[32minstall nodejs dependencies\e[0m"
 npm install &>>${log}
 status_check

 systemd_setup
 
 load_schema
}


 maven() {
 print_head "install maven"
 dnf install maven -y &>>${log}
 status_check
 
 print_head "build a package"
 mvn clean package
 mv target/$component-1.0.jar $component.jar
 status_check
 }

python() {
 print_head "install python 3.6"
 dnf install python36 gcc python3-devel -y
 status_check

 app_prereq

 print_head "download dependencies"
 cd /app
 pip3.6 install -r requirements.txt
 status_check

 systemd_setup
}
