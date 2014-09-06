#!/bin/bash

### Autoinstall SABNZBD - Couchpotato - Sickbeard - Heaphones on Ubuntu

DOWNLOADDIRECTORY="";
MOVIEDIRECTORY="";
MUSICDIRECTORY="";
SERIESDIRECTORY="";
INSTALLLOCATION="";
UNAME="thinksmart";
EMAIL="";
MAILSERVER="";

#Generate api keys
# cat /dev/urandom | LANG=C tr -dc '0-9a-f'|head -c 32
API_KEY=$(cat /dev/urandom | LANG=C tr -dc '0-9a-f'|head -c 32);
RATING_API_KEY=$(cat /dev/urandom | LANG=C tr -dc '0-9a-f'|head -c 32);
NZB_KEY=$(cat /dev/urandom | LANG=C tr -dc '0-9a-f'|head -c 32);


# Keep-alive: update existing sudo time stamp if set, otherwise do nothing.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
 

#create directories needed
if [ ! -d "/home/$UNAME" ]; then
  echo 'Bummer! You may not have entered your username correctly. Exiting now. Please rerun script.'
  echo
  exit 0
fi

if [ ! -d "/home/$UNAME/.pid" ]; then
	mkdir "/home/$UNAME/.pid";
else
	echo "/home/$UNAME/.pid allready exists";
fi

if [ ! -d "/home/$UNAME/.config" ]; then
	mkdir "/home/$UNAME/.config";
	mkdir "/home/$UNAME/.config/couchpotato";
	mkdir "/home/$UNAME/.config/sickbeard";
	mkdir "/home/$UNAME/.config/sabnzbdplus";
else
	echo "/home/$UNAME/.config allready exists";
fi



echo "Installing SabNZBd";

#Update apt get
sudo apt-get update;

# install sabnzbd repo
#sudo add-apt-repository ppa:jcfp/ppa;

# install sabnzbd
sudo apt-get -y install sabnzbdplus;

# Editing default config	

sleep 1
echo "#SABNZBDplus default config" >> sabnzbdplus
echo "#" >> sabnzbdplus
echo "# When SABnzbd+ is started using the init script, the" >> sabnzbdplus
echo "# --daemon option is always used, and the program is" >> sabnzbdplus
echo "# started under the account of $USER, as set below." >> sabnzbdplus
echo "#" >> sabnzbdplus
echo "# Each setting is marked either required or optional;" >> sabnzbdplus
echo "# leaving any required setting unconfigured will cause" >> sabnzbdplus
echo "# the service to not start." >> sabnzbdplus
echo " " >> sabnzbdplus
echo "# [required] user or uid of account to run the program as:" >> sabnzbdplus
echo "USER="$UNAME >> sabnzbdplus
echo " " >> sabnzbdplus
echo "# [optional] full path to the configuration file of your choice;" >> sabnzbdplus
echo "#            otherwise, the default location (in USERS home" >> sabnzbdplus
echo "#            directory) is used:" >> sabnzbdplus
echo "CONFIG=/home/"$UNAME"/.config/sabnzbdplus/sabnzbd.ini" >> sabnzbdplus
echo " " >> sabnzbdplus
echo "# [optional] hostname/ip and port number to listen on:" >> sabnzbdplus
echo "HOST=0.0.0.0" >> sabnzbdplus
echo "PORT=8080" >> sabnzbdplus
echo " " >> sabnzbdplus
echo "# [optional] extra command line options, if any:" >> sabnzbdplus
echo "EXTRAOPTS=--browser 0" >> sabnzbdplus
sudo mv sabnzbdplus /etc/default/
sudo chmod +x /etc/default/sabnzbdplus		

# Edit sabnzbd.ini and move into place


# Install Couchpotato

sudo sh cp-installer.sh $UNAME;

# Edit cp-config.ini and move into place



# Install Sickbeard

sudo sh sb-installer.sh $UNAME;

/etc/init.d/couchpotato start
/etc/init.d/sickbeard start

exit 0