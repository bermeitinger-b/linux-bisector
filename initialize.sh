#!/bin/sh
basedir=$(pwd)

if [ ! -d "$basedir/linux" ]; then
    git clone https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
    cd linux && git remote add linux-next https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git && git fetch linux-next && cd ..
fi

echo "" >"$basedir/built_commits.txt"

cd "$basedir/linux"
git bisect start
cd "$basedir"
