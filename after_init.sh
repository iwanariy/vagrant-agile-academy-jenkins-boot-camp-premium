#!/bin/sh

## Install Chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
sudo apt-get update
sudo apt-get -y install google-chrome-stable

## Download ChromeDriver, Deploy it to PATH
wget https://chromedriver.googlecode.com/files/chromedriver_linux32_2.2.zip
sudo apt-get -y install unzip
sudo unzip chromedriver_linux32_2.2.zip 
sudo chmod 755 chromedriver
sudo mv chromedriver /usr/bin/

## Install Firefox
sudo apt-get -y install firefox

## Install Xvfb
sudo apt-get -y install xvfb
sudo apt-get -y install vim
sudo apt-get install -y openjdk-7-jdk
sudo update-alternatives --set java /usr/lib/jvm/java-7-openjdk-i386/jre/bin/java
sudo apt-get install -y maven
sudo apt-get install -y tomcat7 tomcat7-admin tomcat7-examples
sudo sed -i -e 's/<Connector port="8080"/<Connector port="8888"/' /etc/tomcat7/server.xml
sudo sed -i -e 's/\(<tomcat-users>\)/\1<user username="admin" password="admin" roles="manager-gui,manager-script"\/>/' /etc/tomcat7/tomcat-users.xml
sudo /etc/init.d/tomcat7 restart

## Startt git-deamon
sudo apt-get -y install git-daemon-run

sudo sed -i -e 's/\(--base-path=\/var\/cache \/var\/cache\/git\)/--enable=receive-pack \1/' /etc/sv/git-daemon/run
sudo sv start git-daemon
cd /var/cache/git/
sudo mkdir AASample.git
ls -al
cd AASample.git/
sudo git init --bare
sudo touch git-daemon-export-ok
cd ../
sudo chown -R gitdaemon:root AASample.git

sleep 10

## Clone AASample and add remote
cd 
git config --global user.name "root"
git config --global user.email root@precise64
git clone git://192.168.100.132/cidev/AASample.git
cd AASample/
rm -rf .git
git init
git add .
git commit -m "init"
git remote add origin git://localhost/git/AASample.git
git push origin master

sudo ln -s -f /dev/null /etc/udev/rules.d/70-persistent-net.rules
sudo ln -f -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

echo "Asia/Tokyo" > timezone
sudo cp timezone /etc/timezone
rm timezone
dpkg-reconfigure -f noninteractive tzdata
