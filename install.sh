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
sudo apt-get install samba samba-common-bin
sudo apt-get install build-essential bc git
sudo apt install raspberrypi-kernel
sudo apt install raspberrypi-kernel-headers
git clone https://github.com/pstolarz/w1-gpio-cl.git
cd w1-gpio-cl
make
sudo make install

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
##################################################

echo "Input your workgroup name:"
read WORKGROUP_N
sed -i.bak -E '/^.*workgroup =.*$/d' /etc/samba/smb.conf

echo "workgroup = $WORKGROUP_N" >> /etc/samba/smb.conf
echo "[share_pi]" >> /etc/samba/smb.conf
echo "comment=Raspberry Pi Share" >> /etc/samba/smb.conf
echo "path=/home/pi/share" >> /etc/samba/smb.conf
echo "browseable=Yes" >> /etc/samba/smb.conf
echo "writeable=Yes" >> /etc/samba/smb.conf
echo "guest ok =Yes" >> /etc/samba/smb.conf
echo "create mask=0777" >> /etc/samba/smb.conf
echo "directory mask=0777" >> /etc/samba/smb.conf
service smbd restart
####################################################

MAC_ADDR=$(cat /sys/class/net/eth0/address)
sed -i "s/.*test_subj=.*/test_subj=\"mac=${MAC_ADDR};vpn=192.169.3.3\"/" processmail_sh1



chmod +x Current-Map_.rep mail_sh2 on_off_sh2 on_reboot_sh2 onewire_sh1 processmail_sh1 supervise_sh1 thermo_sh1 Trends_ddp.rep
mv Current-Map_.rep mail_sh2 on_off_sh2 on_reboot_sh2 onewire_sh1 processmail_sh1 supervise_sh1 thermo_sh1 Trends_ddp.rep /usr/local/bin/

sudo /usr/local/bin/on_reboot_sh2


