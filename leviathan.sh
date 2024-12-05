#!/bin/bash 
# Install Dependencies
sudo apt-get install figlet -y -qq &> /dev/null #Installs for dat style
sleep 1s 
clear
tput setaf 2 # Sets color to Green
#Enviromental Variables 
USER_GRAFANA="ADMIN"
PASSWORD_GRAFANA="=7(SfVJ%wA_B7B{q(3TkLe@x36/q4.s{zb~yGY"
USER_INFLUX="ADMIN"
PASSWORD_INFLUX="{k7ws3/#Bv>@BL&<[_HHww?YTqZAsN9gfv#{!L"
PREFIX="[LEVIATHAN]"
# Functions 

#Grafana Install Function
function Grafana () {
    echo $PREFIX Downloading Grafana Dependencies
    sudo apt install -y software-properties-common wget apt-transport-https &> /dev/null
    echo $PREFIX Retrieving and Adding Grafana GPG Key
    wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add - &> /dev/null
    echo $PREFIX Adding Stable Repository to Source List
    echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list &> /dev/null
    echo $PREFIX Updating Source List
    sudo apt update -y  &> /dev/null
    echo $PREFIX Installing and Enabling Grafana
    sudo apt install -y grafana &> /dev/null
    sleep 10s #Wait for Grafana setup
    sudo systemctl enable grafana-server &> /dev/null
    sudo systemctl start grafana-server &> /dev/null
    echo $PREFIX Importing custom config
    sudo cp Grafana/grafana.ini /etc/grafana/grafana.ini &> /dev/null
    echo $PREFIX Creating Credentials 
    sudo grafana-cli admin $PASSWORD_GRAFANA  &> /dev/null
    echo $PREFIX Grafana Installation Complete. 
    sleep 2s


}
              
#InfluxDB Install Function
function InfluxDB () { 
    echo $PREFIX Retrieving InfluxDB GPG Key and Adding it
    curl -s https://repos.influxdata.com/influxdb.key | sudo apt-key add - &> /dev/null
    echo $PREFIX Recovering Distrib Information
    source /etc/lsb-release &> /dev/null
    echo $PREFIX Adding Stable Repository to Source List 
    echo "deb https://repos.influxdata.com/${DISTRIB_ID,,} ${DISTRIB_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/influxdb.list &> /dev/null
    echo $PREFIX Updating Source List 
    sudo apt update -y &> /dev/null
    echo $PREFIX Installing InfluxDB 
    sudo apt install -y influxdb &> /dev/null
    echo $PREFIX Unmasking,Enabling and Starting InfluxDB 
    sudo systemctl unmask influxdb.service &> /dev/null
    sudo systemctl enable influxdb &> /dev/null
    sudo systemctl start influxdb &> /dev/null
    sleep 10s #Wait for Influxd to start up
    echo $PREFIX Enabling Default Ports 
    sudo ufw allow 8086 8088 &> /dev/null
    echo $PREFIX Importing custom config
    sudo cp InfluxDB/influxdb.conf /etc/influxdb/influxdb.conf &> /dev/null
    echo $PREFIX Creating Credentials
    sudo influx user create -n $USER_INFLUX -p $PASSWORD_INFLUX  &> /dev/null
    echo $PREFIX InfluxDB Installation Complete. 
    sleep 2s  
} 

# Title + Menu
figlet -w 500  Project Leviathan
figlet -w 100 by WarpWing
sleep 3s
clear 
echo $PREFIX Welcome to Project Leviathan
read -p "$PREFIX Are you ready to begin installing? [y/n]: " INPUT
if [[ $INPUT == y ]]
then
  cd /tmp/
  git clone https://github.com/Scorvia-Solutions/Leviathan.git &> /dev/null
  cd Leviathan/
  InfluxDB
  Grafana
  echo $PREFIX Automatic Install Complete! Make sure to check that everything is properly configured!
  echo $PREFIX Please remember that the default user and password for Grafana is $USER_GRAFANA : $PASSWORD_GRAFANA
  echo $PREFIX Also note that the default user and password for InfluxDB is $USER_INFLUX : $PASSWORD_INFLUX
  echo $PREFIX Project Leviathan Install Complete. Session Terminating in 3 seconds
  sleep 3s
else
  echo Terminating Installation
fi
