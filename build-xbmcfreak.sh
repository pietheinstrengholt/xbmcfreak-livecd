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
    echo "xbmc-live dir already exists"
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
#sed -i "s/fglrx/#fglrx/g" $WORKDIR/buildLive/Files/chroot_local-packageslists/packages.list
#sed -i "s/xbmc-ppa-keyring/#xbmc-ppa-keyring/g" $WORKDIR/buildLive/Files/chroot_local-packageslists/packages.list
sed -i "s/uxlaunch//g" $WORKDIR/buildLive/Files/chroot_local-packageslists/packages.list
echo "libao-dev avahi-utils" >> $WORKDIR/buildLive/Files/chroot_local-packageslists/packages.list


#new build.sh script
cp files/build.sh $WORKDIR/ -Rf

#add additional files
cp files/chroot_local-includes/* $WORKDIR/buildLive/Files/chroot_local-includes/ -Rf
cp files/binary_grub/* $WORKDIR/buildLive/Files/binary_grub/ -Rf
cp files/finish-install.d/* $WORKDIR/buildDEBs/xbmclive-installhelpers/finish-install.d/ -Rf
cp files/post-base-installer.d/* buildDEBs/xbmclive-installhelpers/post-base-installer.d/ -Rf

#add addtional sources
rm $WORKDIR/buildLive/Files/chroot_sources/xbmc* -rf
cp files/chroot_sources/* $WORKDIR/buildLive/Files/chroot_sources/ -Rf

#add hooks
cp files/buildHook-*.sh $WORKDIR/ -Rf

#temp fix build
rm $WORKDIR/buildLive/Files/chroot_local-hooks/00-installCrystalHD
rm $WORKDIR/buildLive/Files/chroot_local-hooks/99-checkKernels
rm $WORKDIR/buildLive/Files/chroot_local-hooks/13-setTvheadend
rm $WORKDIR/buildLive/Files/binary_local-includes/install/Hooks/setup_uxlaunch.sh
rm $WORKDIR/buildLive/Files/chroot_local-hooks/20-uxlaunchConfig

cd $THISDIR

#check if xbmc-live dir already exists
if [ -d "xbmc-remote-php" ]; then
    echo "xbmc-remote-php dir already exists"
    rm -rf xbmc-remote-php
fi

#clone xbmc-remote-php
git clone git@github.com:xbmcfreak/xbmc-remote-php.git

#copy xbmc-remote-php dir
#mkdir $WORKDIR/buildLive/Files/chroot_local-includes/var/
#mkdir $WORKDIR/buildLive/Files/chroot_local-includes/var/www/
mv xbmc-remote-php/ $WORKDIR/buildLive/Files/chroot_local-includes/var/www

#start building
cd $WORKDIR
./build.sh

#copy binary files
cd $THISDIR
if [ -f $WORKDIR/binary.iso ]; then
        mv $WORKDIR/binary.* .
        chmod 777 binary.*
fi

