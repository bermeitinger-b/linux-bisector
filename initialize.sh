#!/bin/sh
basedir=$(pwd)

if [ ! -d "$basedir/linux" ]; then
    git clone https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
fi

echo "" > "$basedir/built_commits.txt"

cd "$basedir/linux"
git bisect start
cd "$basedir"