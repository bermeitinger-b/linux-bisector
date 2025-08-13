#!/bin/sh
basedir="$(pwd)"
rm -rf src pkg ./*.tar.zst ./*.tar.gz
cd "$basedir/linux" || exit
git log -1 --pretty=format:"%H" | tee -a "$basedir/built_commits.txt"
cd "$basedir" || exit
tar --exclude-vcs -czvf linux.tar.gz ./linux/
export BUILDDIR="${HOME}/.cache/makepkg"
makepkg --syncdeps --force --install --sign
