#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
echo "This script must be run as root" 1>&2
    exit 1
fi

#set variables
THISDIR=$(pwd)
WORKDIR=xbmc-live/SDK

#check if xbmc-live dir already exists
if [ -d "xbmc-live" ]; then
echo "xbmc-live dir already exists, remove xbmc-live dir"
    rm -rf xbmc-live
fi

#clone xbmc-live from xbmc.org
if [ "$1" == maverick ]; then
echo "clone xbmc-live maverick"
     git clone -b maverick git@github.com:xbmc/xbmc-live.git
else
echo "clone xbmc-live master"
     git clone git@github.com:xbmc/xbmc-live.git
fi

#add additional packages
echo "samba" >> $WORKDIR/buildLive/Files/chroot_local-packageslists/packages.list
echo "proftpd-basic" >> $WORKDIR/buildLive/Files/chroot_local-packageslists/packages.list
echo "wget lynx lftp ftp zip" >> $WORKDIR/buildLive/Files/chroot_local-packageslists/packages.list
echo "sabnzbdplus sabnzbdplus-theme-mobile" >> $WORKDIR/buildLive/Files/chroot_local-packageslists/packages.list
echo "lm-sensors" >> $WORKDIR/buildLive/Files/chroot_local-packageslists/packages.list
echo "transmission-cli transmission-daemon transmission-common" >> $WORKDIR/buildLive/Files/chroot_local-packageslists/packages.list
echo "apache2 libapache2-mod-php5 php5-common php5-curl" >> $WORKDIR/buildLive/Files/chroot_local-packageslists/packages.list
echo "libid3tag0 mt-daapd" >> $WORKDIR/buildLive/Files/chroot_local-packageslists/packages.list
echo "python-software-properties" >> $WORKDIR/buildLive/Files/chroot_local-packageslists/packages.list
echo "locate ethtool" >> $WORKDIR/buildLive/Files/chroot_local-packageslists/packages.list
echo "nfs-common" >> $WORKDIR/buildLive/Files/chroot_local-packageslists/packages.list
#use latest fglrx (not from ppa)
sed -i "s/fglrx/#fglrx/g" $WORKDIR/buildLive/Files/chroot_local-packageslists/packages.list
#xbmc-ppa-keyring is not present in unstable
sed -i "s/xbmc-ppa-keyring/#xbmc-ppa-keyring/g" $WORKDIR/buildLive/Files/chroot_local-packageslists/packages.list
echo "libao-dev avahi-utils" >> $WORKDIR/buildLive/Files/chroot_local-packageslists/packages.list
echo "upower acpi-support" >> $WORKDIR/buildLive/Files/chroot_local-packageslists/packages.list
echo "libmad0" >> $WORKDIR/buildLive/Files/chroot_local-packageslists/packages.list
echo "nvidia-settings" >> $WORKDIR/buildLive/Files/chroot_local-packageslists/packages.list

#add additional files
rm $WORKDIR/buildLive/Files/chroot_sources/xbmc* -rf
cp files/* $WORKDIR/ -Rf

#start building
cd $WORKDIR
#./build.sh
./buildWithOptions.sh -N --x-swat

#copy binary files
cd $THISDIR
if [ -f $WORKDIR/binary.iso ]; then
mv $WORKDIR/binary.* .
        chmod 777 binary.*
fi
