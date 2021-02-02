#!/bin/bash

cd / || exit 1

if ! ln -sf /usr/share/zoneinfo/Europe/Dublin /etc/localtime ; then echo "timezone file fucked" && exit 1 ; fi

hwclock --systohc

locale-gen locale-gen en_US en_US.UTF-8 

touch /etc/hostname
echo foxxo >> /etc/hostname
touch /etc/hosts
echo "

127.0.0.1  localhost
::1  localhost
127.0.1.1  foxxo.localdomain  myhostname

" >> /etc/hosts


echo "updating mkinitcpio"
mkinitcpio -P

echo "Time to set root pass."

passwd

pacman -Syu amd-ucode efibootmgr mtools dosfstools vim nvidia cowsay figlet toilet git grub os-prober networkmanager sudo wget

useradd --create-home mia


usermod --append --groups wheel,audio,video,optical,storage mia
passwd mia

visudo



echo "grub it up!"
mkdir /boot/efi
if ! mount /dev/nvme0n1p1 /mnt/boot/efi ; then echo "mounting efi is fucked" && exit 1 ; fi
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB_UEFI --recheck
grub-mkconfig -o /boot/grub/grub.cfg
vim /etc/vconsole.conf

echo "all done. you SHOULD be able to reboot now."

