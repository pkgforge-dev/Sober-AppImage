#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm webkitgtk-6.0 libadwaita

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

mkdir -p ./AppDir/bin
bin=$(wget --retry-connrefused --tries=30 \
	https://github.com/flathub/org.vinegarhq.Sober/blob/master/org.vinegarhq.Sober.yml  -O - \
	| sed 's/[()",{} ]/\n/g' | grep -o -m 1 'https://sober.vinegarhq.org.*/sober-binaries-unified.tar.zst')
wget --retry-connrefused --tries=30 "$bin" -O /tmp/tarball.tar.zst
tar xvf /tmp/tarball.tar.zst

cp -rv ./sober-binaries-unified/*              ./AppDir/bin

awk -F'=|"' '/release version=/{print $3; exit}' ./AppDir/bin/org.vinegarhq.Sober.metainfo.xml > ~/version
