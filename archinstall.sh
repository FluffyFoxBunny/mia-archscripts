#!/bin/bash

#FUCK IM LAZY THIS DOES IT FOR ME

#Swap partition 
SW=/dev/sda1
#Main partition 
MP=/dev/nvme0n1p2

pacman -S wget git


echo "
Listen bitch, read the file first,
don't FUCK THIS UP

Install disk: $MP 
Swap: $SW 

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
if ! mkfs.ext4 $MP ; then echo "mkfs.ext4 is fucked" && exit 1 ; fi

echo "swap shit idk why."
if ! mkswap $SW ; then echo "mkswap is fucked" && exit 1 ; fi
if ! swapon $SW ; then echo "swapons fucked" && exit 1 ; fi

echo "i guess maybe if that worked we're ok?"



#====================================================

echo "We're mounting now"

if ! mount $MP /mnt ; then echo "mounting $MP is fucked" && exit 1 ; fi

echo "We're mounted. let's download"
if ! pacstrap /mnt base base-devel linux linux-firmware linux-headers nvidia ; then echo "install is fucked" && exit 1 ; fi

echo "Assuming the arch install didn't shit the bed, we can now gen our fstab"
if ! genfstab -U /mnt >> /mnt/etc/fstab ; then echo "genfstab is fucked" && exit 1 ; fi

cd /mnt/etc/ || exit
if ! git clone https://github.com/violetvulpine/mia-archscripts.git ; then echo "git is fucked" ; fi

chmod +x /mnt/etc/mia-archscripts/*

echo "bitch it's kinda nearly there! 
do arch-chroot /mnt then start /etc/mia-archscripts/archinstall2.sh
i chmodded them and all!"
