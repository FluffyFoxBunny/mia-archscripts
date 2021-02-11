#!/bin/bash

#FUCK IM LAZY THIS DOES IT FOR ME

pacman -S wget git

echo "
Listen bitch, read the file first,
don't FUCK THIS UP

make sure you have the partable done, do that
thing with the numbers and shit. 

type 'jizz' to confirm you're not drunk or high

or dont idgaf
"


read -r jizz

if [ "$jizz" != "jizz" ]; then
    echo "YOU DUMBASS"
    exit 1
fi

echo "YOUVE BEEN WARNED"




#============================================================

echo "first my main disk"
if ! mkfs.ext4 /dev/nvme0n1p4 ; then echo "mkfs.ext4 is fucked" && exit 1 ; fi

echo "swap shit idk why."
if ! mkswap /dev/sdb3 ; then echo "mkswap is fucked" && exit 1 ; fi
if ! swapon /dev/sdb3 ; then echo "swapons fucked" && exit 1 ; fi

echo "i guess maybe if that worked we're ok?"



#====================================================

echo "We're mounting now"

if ! mount /dev/nvme0n1p4 /mnt ; then echo "mounting nvme0n1p4 is fucked" && exit 1 ; fi

echo "We're mounted. let's download"
if ! pacstrap /mnt base base-devel linux Linux-firmware nvidia ; then echo "install is fucked" && exit 1 ; fi

echo "Assuming the arch install didn't shit the bed, we can now gen our fstab"
if ! genfstab -U /mnt >> /mnt/etc/fstab ; then echo "genfstab is fucked" && exit 1 ; fi

cd /mnt/etc/ || exit
if ! git clone https://github.com/xenolithcluster/mia-archscripts.git ; then echo "git is fucked" ; fi

echo "bitch it's kinda nearly there! 
do arch-chroot /mnt then start archinstall2.sh, i put the files in /etc/mia-archscripts"
