#!/bin/sh
basedir=$(pwd)
sudo rm -rf src pkg *.tar.zst *.tar.gz
cd "$basedir/linux"
git log -1 --pretty=format:"%H" | tee -a "$basedir/built_commits.txt"
cd "$basedir"
tar --exclude-vcs -czvf linux.tar.gz ./linux/
makepkg -sf
