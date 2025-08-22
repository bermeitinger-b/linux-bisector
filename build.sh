#!/bin/sh
basedir="$(pwd)"
rm -rf src pkg ./*.tar.zst ./*.tar.zst.sig ./*.tar.gz
cd "$basedir/linux" || exit
git log -1 --pretty=format:"%H%n" | tee -a "$basedir/built_commits.txt"
git describe --long | sed -E 's/([^-]*-g)/r\1/;s/-/./g' | tee "pkgver.txt"
cd "$basedir" || exit
tar --exclude-vcs -czf linux.tar.gz ./linux/
export BUILDDIR="${HOME}/.cache/makepkg"
makepkg --syncdeps --force --sign
