#!/bin/bash

cd $HOME
rm -f *.deb

cd $HOME/mptcp
git pull

DATE=`date "+%Y%m%d%H%M%S"`
KVERS=`make kernelversion`
make -j 8 deb-pkg DEBEMAIL='christoph.paasch@gmail.com' DEBFULLNAME='Christoph Paasch' LOCALVERSION=.mptcp KDEB_PKGVERSION=${DATE}

cd $HOME

# Create meta-package
rm -Rf linux-mptcp

mkdir linux-mptcp
mkdir linux-mptcp/DEBIAN
chmod -R a-s linux-mptcp
ctrl="linux-mptcp/DEBIAN/control"
touch $ctrl

echo "Package: linux-mptcp" >> $ctrl
echo "Version: ${DATE}" >> $ctrl
echo "Section: main" >> $ctrl
echo "Priority: optional" >> $ctrl
echo "Architecture: all" >> $ctrl
echo "Depends: linux-headers-${KVERS}.mptcp, linux-image-${KVERS}.mptcp" >> $ctrl
echo "Installed-Size:" >> $ctrl
echo "Maintainer: Christoph Paasch <christoph.paasch@gmail.com>" >> $ctrl
echo "Description: A meta-package for linux-mptcp" >> $ctrl

dpkg --build linux-mptcp

mv linux-mptcp.deb linux-mptcp_${DATE}_all.deb

