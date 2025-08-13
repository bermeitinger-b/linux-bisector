# Archlinux kernel bisector

This is a bisect that will allow loading dkms modules and play nice with archlinux in general.

Setup the build script by cloning this repository.

## Setting up the build environment

This is common for every archlinux derivative:

```sh
sudo pacman -S base-devel gcc ccache bc flex bison make
```

## Setting up ccache
To speed up compilation of code that is very similar (it will be increasingly important as you reach the end of the bisect) ccache is used.

Install ccache:
```sh
sudo pacman -S ccache
```

Then assign ccache a lot of space to work:

```sh
ccache -M 100G # 100 GB, feel free to lower this
```

When you will have completed the bisect remember to clean that used space:

```sh
ccache -C
```

## Bisecting

To initialize the linux kernel sources and start the bisect you use the script initialize.sh

```sh
./initialize.sh
```

After this git will await for a known good and known bad commit, so assume you know 6.15.9 works and 6.16.0 does not,
you need to confirm this is what you see while bisecting, otherwise the problem might be elsewhere or the configuration
in use is unsuitable to reproduce the bug.

Head over the linux directory and checkout the known broken version:

```sh
cd linux
git checkout v6.16.0
```

Then proceed compiling the kernel:

```sh
./build.sh
```

Once that is done you can install the compiled version doing

```sh
run0 pacman -U *.tar.zst --overwrite "/usr/lib/modules/*bisector*"
```

Reboot and select the _bisector_ kernel.

```sh
cd linux
git bisect bad
```

Then do the same thing with v6.15.9, so:

```sh
cd linux
git checkout v6.15.9
cd ..
./build.sh
run0 pacman -U *.tar.zst --overwrite "/usr/lib/modules/*bisector*"
```

And reboot again into linux-bisector. If the bug is not there you can start your git bisect marking the first good commit:

```sh
cd linux
git bisect good
```

From this moment until the end of the bisect each time you do git bisect bad or git bisect good, git will change the 
current commit on the linux directory giving you something new to try until the bisect will be over.

Repeat this step as many times as needed:

```sh
cd linux
git bisect (good|bad) # good or bad depends if on the current reboot of linux-bisector you could reproduce the bug or not
# git has moved to a new commit
cd ..
./build.sh # build that new commit
run0 pacman -U *.tar.zst --overwrite "/usr/lib/modules/*bisector*"
systemctl reboot # and remember to pick linux-bisector
```

At the end git will tell you the first commit that has caused the bug you are attempting to have fixed.

## Suggestions

Screwing up is easy, very easy and it will cost you hours of work.

You know you have screwed up when the bisect ends in a commit that is totally unrelated to what you are looking for,
say you are looking for a bug in amdgpu and you end up in a bcachefs commit (bcachefs is not even compiled):
this is an example of a major screwup! *just for reference, every reference is purely random and is surely never happened to me*.

Common reasons for screwing up are:
1) you booted your normal kernel instead of linux-bisector, because the bootloader is not properly configured and you can only find good or bad commits.
2) you booted your normal kernel because you forgot to spam arrow down during boot.
3) you write bad instead of good or the other way around

To prevent 1 and 2 each time you boot do

```sh
uname -a
```

and save the result in a new line of file steps.txt. After verifying if the commit is good or bad do:

```sh
git log -1 --pretty=format:"%H"
```

append this to the steps.txt file and write after the commit if it was good or bad.
