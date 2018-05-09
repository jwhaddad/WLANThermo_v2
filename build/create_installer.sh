#!/bin/bash

cd "${BASH_SOURCE%/*}" || exit

echo Kopiere Software in das Buildverzeichniss...
cp -r ../software/* ./build/
echo Kopiere Paketdaten in das Buildverzeichniss...
cp -r ../DEBIAN ./build/
echo Kopiere Changelog in das Buildverzeichniss...
cp -r ../changelog ./build/DEBIAN/changelog

echo Suche Versionsnummer...
VERSION=`dpkg-parsechangelog -lbuild/DEBIAN/changelog --show-field Version`
echo Paketversion: $VERSION
echo Setze Version in den Paketdaten...
echo Version: $VERSION >> ./build/DEBIAN/control
echo Setze Version in der header.php...
sed -i -e "s/XXX_VERSION_XXX/V${VERSION}/g" ./build/var/www/header.php
sed -i -e "s/XXX_VERSION_XXX/V${VERSION}/g" ./build/usr/sbin/wlt_2_nextion.py

echo Baue Paket...
dpkg -b ./build ./package/wlanthermo-$VERSION.deb

echo Baue Installer...
cat ./installer/installer.sh ./package/wlanthermo-$VERSION.deb > ./run/WLANThermo_install-$VERSION.run
chmod +x ./run/WLANThermo_install-$VERSION.run

echo Lösche Buildverzeichniss...
rm -r ./build/*
