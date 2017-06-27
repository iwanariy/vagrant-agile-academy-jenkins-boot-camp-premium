#!/bin/sh

apt-get update

## Install chromium-driver
apt-get -y install unzip chromium-chromedriver
wget http://chromedriver.storage.googleapis.com/2.30/chromedriver_linux32.zip
unzip chromedriver_linux32.zip 
mv chromedriver /usr/bin

## Install Firefox
apt-get -y install firefox
wget https://github.com/mozilla/geckodriver/releases/download/v0.17.0/geckodriver-v0.17.0-linux32.tar.gz
tar -zxvf geckodriver-v0.17.0-linux32.tar.gz 
mv geckodriver /usr/bin

## Install Java 8
apt-get -y install software-properties-common python-software-properties
add-apt-repository ppa:openjdk-r/ppa
apt-get update
apt-get install -y openjdk-8-jdk
update-alternatives --set java /usr/lib/jvm/java-8-openjdk-i386/jre/bin/java

## Install Xvfb and Tomcat 7
apt-get -y install xvfb vim maven tomcat7 tomcat7-admin tomcat7-examples
sed -i -e 's/<Connector port="8080"/<Connector port="8888"/' /etc/tomcat7/server.xml
sed -i -e 's/\(<tomcat-users>\)/\1<user username="admin" password="admin" roles="manager-gui,manager-script"\/>/' /etc/tomcat7/tomcat-users.xml
/etc/init.d/tomcat7 restart

## Start git-deamon
apt-get -y install git-daemon-run

sed -i -e 's/\(--base-path=\/var\/lib \/var\/lib\/git\)/--enable=receive-pack \1/' /etc/sv/git-daemon/run
sv start git-daemon
cd /var/lib/git/
mkdir AASample.git
ls -al
cd AASample.git/
git init --bare
touch git-daemon-export-ok
cd ../
chown -R gitdaemon:root AASample.git

sleep 10

## Clone AASample and add remote
cd 
git config --global user.name "root"
git config --global user.email root@precise32
git clone https://github.com/ootaken/AASample.git
cd AASample/
rm -rf .git
git init
git add .
git commit -m "init"
git remote add origin git://localhost/git/AASample.git
git push origin master

git config --global user.name "vagrant"
git config --global user.email vagrant@precise32

ln -s -f /dev/null /etc/udev/rules.d/70-persistent-net.rules
ln -f -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

echo "Asia/Tokyo" > timezone
cp timezone /etc/timezone
rm timezone
dpkg-reconfigure -f noninteractive tzdata
apt-get -y install language-pack-ja
localectl set-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja" 
