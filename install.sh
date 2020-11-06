#!/bin/bash

MAIL_ADDR='raspberry_pi@bk.ru'
PASSWD=''

#color
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
PURPLE="\033[0;35m"
RED='\033[0;31m'
GREEN="\033[0;32m"
NC='\033[0m'
MAG='\e[1;35m'
cd raspi.collector
echo -e "${CYAN}Prepare Installation...${NC}"
sudo apt update
sudo apt -y install pptp-linux
sudo apt-get -y install mosquitto mosquitto-clients
sudo apt-get -y install gnuplot
sudo apt-get -y install mailutils
sudo apt-get -y install ssmtp
sudo apt-ge -yt install samba samba-common-bin
sudo apt-get -y install build-essential bc git
sudo apt -y install raspberrypi-kernel
sudo apt -y install raspberrypi-kernel-headers
echo -e "${CYAN}Building bin files...${NC}"
git clone https://github.com/pstolarz/w1-gpio-cl.git
cd w1-gpio-cl
make
sudo make install
cd ..
###############################################
#Create /etc/ssmtp/ssmtp.conf
echo -e "${CYAN}Creating configuration...${NC}"
echo -e "root=$MAIL_ADDR" > /etc/ssmtp/ssmtp.conf
echo 'mailhub=smtp.mail.ru' >> /etc/ssmtp/ssmtp.conf
echo 'hostname=raspberry' >> /etc/ssmtp/ssmtp.conf
echo 'UseTLS=YES' >> /etc/ssmtp/ssmtp.conf
echo 'UseSTARTTLS=YES' >> /etc/ssmtp/ssmtp.conf
echo 'AuthMethod=LOGIN' >> /etc/ssmtp/ssmtp.conf
echo -e "AuthUser=$MAIL_ADDR" >> /etc/ssmtp/ssmtp.conf
echo -n -e "${YELLOW}Input mail password:${NC}"
read PASSWD
echo -e "AuthPass=$PASSWD" >> /etc/ssmtp/ssmtp.conf    #a27TLxmqGdqgJ7N           
echo 'FromLineOverride=NO' >> /etc/ssmtp/ssmtp.conf
##################################################
#Create /etc/ssmtp/revaliases
echo -e "root:$MAIL_ADDR" > /etc/ssmtp/revaliases
echo -e "pi:raspberry_pi@bk.ru" >> /etc/ssmtp/revaliases
##################################################

echo -e -n "${YELLOW}Input your workgroup name:${NC}"
read WORKGROUP_N
sed -i "s/.*workgroup =.*/workgroup = ${WORKGROUP_N}/" /etc/samba/smb.conf

echo "[share_pi]" >> /etc/samba/smb.conf
echo " comment=Raspberry Pi Share" >> /etc/samba/smb.conf
echo " path=/home/pi/share" >> /etc/samba/smb.conf
echo " browseable=Yes" >> /etc/samba/smb.conf
echo " writeable=Yes" >> /etc/samba/smb.conf
echo " guest ok =Yes" >> /etc/samba/smb.conf
echo " create mask=0777" >> /etc/samba/smb.conf
echo " directory mask=0777" >> /etc/samba/smb.conf
service smbd restart
####################################################
MAC_ADDR=$(cat /sys/class/net/eth0/address)
sed -i "s/.*test_subj=.*/test_subj=\"mac=${MAC_ADDR};vpn=192.169.3.3\"/" processmail_sh1

echo -e "${CYAN}Copy files...${NC}"
chmod +x Current-Map_.rep mail_sh2 on_off_sh2 on_reboot_sh2 onewire_sh1 processmail_sh1 supervise_sh1 thermo_sh1 Trends_ddp.rep
mv Current-Map_.rep mail_sh2 on_off_sh2 on_reboot_sh2 onewire_sh1 processmail_sh1 supervise_sh1 thermo_sh1 Trends_ddp.rep /usr/local/bin/

sudo /usr/local/bin/supervise_sh1 &
cd ..
rm -rf raspi.collector
echo -e "${GREEM}All Done! ${NC}"

