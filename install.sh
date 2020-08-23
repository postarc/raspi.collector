#!/bin/bash

MAIL_ADDR='raspberry_pi@bk.ru'
PASSWD=''

sudo apt update
sudo apt dist-upgrade
sudo apt install pptp-linux
sudo apt-get install mosquitto mosquitto-clients
sudo apt-get install gnuplot
sudo apt-get install mailutils
sudo apt-get install ssmtp
sudo nano /etc/ssmtp/ssmtp.conf

###############################################
#Create /etc/ssmtp/ssmtp.conf
echo -e "root=$MAIL_ADDR" > /etc/ssmtp/ssmtp.conf
echo 'mailhub=smtp.mail.ru' >> /etc/ssmtp/ssmtp.conf
echo 'hostname=raspberry' >> /etc/ssmtp/ssmtp.conf
echo 'UseTLS=YES' >> /etc/ssmtp/ssmtp.conf
echo 'UseSTARTTLS=YES' >> /etc/ssmtp/ssmtp.conf
echo 'AuthMethod=LOGIN' >> /etc/ssmtp/ssmtp.conf
echo -e "AuthUser=$MAIL_ADDR" >> /etc/ssmtp/ssmtp.conf
echo -n "Input mail password:"
read PASSWD
echo -e "AuthPass=$PASSWD" > /etc/ssmtp/ssmtp.conf    #a27TLxmqGdqgJ7N           
echo 'FromLineOverride=NO' >> /etc/ssmtp/ssmtp.conf
##################################################
#Create /etc/ssmtp/revaliases
echo -e "root:$MAIL_ADDR" > /etc/ssmtp/revaliases
echo -e "pi:raspberry_pi@bk.ru" >> /etc/ssmtp/revaliases
