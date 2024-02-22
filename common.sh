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


print() {
  echo -e "\e[1m  \e[0m"
}
