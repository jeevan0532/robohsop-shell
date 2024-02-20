script_location=$(pwd)
set -e 

curl https://nodejs.org/dist/v12.16.1/node-v12.16.1.tar.gz | tar xz
cd node-v*
sudo dnf install gcc-c++ make python2
./configure
make -j4
sudo make install

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
