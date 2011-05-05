#!/bin/sh

#      Copyright (C) 2005-2010 Team XBMC
#      http://www.xbmc.org
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with XBMC; see the file COPYING.  If not, write to
#  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
#  http://www.gnu.org/copyleft/gpl.html


cat > $WORKPATH/buildLive/Files/chroot_sources/suraia.list.chroot << EOF
deb http://ppa.launchpad.net/suraia/ppa/ubuntu lucid main
EOF

cat > $WORKPATH/buildLive/Files/chroot_sources/suraia.list.binary << EOF
deb http://ppa.launchpad.net/suraia/ppa/ubuntu lucid main
EOF

if [ ! -f $WORKPATH/suraia.key ] ; then
        wget --no-proxy -O $WORKPATH/suraia.html "http://keyserver.ubuntu.com:11371/pks/lookup?op=get&search=0x5AA3EE698F0EA6FE7C6BE95661DD528B1D9D38E5"
        if [ "$?" -ne "0" ] || [ ! -f $WORKPATH/suraia.html ] ; then
                echo "Needed keyfile not found, exiting..."
                exit 1
        fi

        #
        # Page structure:
        #
        # <html><head><title> ... </title></head>
        # <body><h1> ... </h1>
        # <pre>
        # -----BEGIN PGP PUBLIC KEY BLOCK-----
        # ...
        # -----END PGP PUBLIC KEY BLOCK-----
        # </pre>
        # </body></html>
        #

        # Filter out all before <pre> and after </pre>
        cat $WORKPATH/suraia.html | sed -e '1,/<pre>/d;/<\/pre>/,$d' > $WORKPATH/suraia.key
        rm $WORKPATH/suraia.html
fi

cp $WORKPATH/suraia.key $WORKPATH/buildLive/Files/chroot_sources/suraia.binary.gpg
cp $WORKPATH/suraia.key $WORKPATH/buildLive/Files/chroot_sources/suraia.chroot.gpg
rm $WORKPATH/suraia.key
