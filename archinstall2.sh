#!/bin/bash

cd / || exit 1

if ! ln -sf /usr/share/zoneinfo/Europe/Dublin /etc/localtime ; then echo "timezone file fucked" && exit 1 ; fi

hwclock --systohc

locale-gen en_US en_US.UTF-8 
localectl set-locale LANG=en_US.UTF-8

touch /etc/hostname
echo foxxo >> /etc/hostname
touch /etc/hosts
echo "

127.0.0.1  localhost
::1  localhost
127.0.1.1  foxxo.localdomain  foxxo

" >> /etc/hosts


echo "updating mkinitcpio"
mkinitcpio -P

echo "Time to set root pass."

passwd

echo "Alright. time to install packages. "

pacman -S $(awk '{print $1}'  /etc/mia-archscripts/list.txt)

useradd --create-home mia
usermod --append --groups wheel,audio,video,optical,storage mia
passwd mia

visudo



echo "grub it up!"
mkdir -p /boot/efi
mount /dev/nvme0n1p1 /boot/efi/
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB_UEFI --recheck
grub-mkconfig -o /boot/grub/grub.cfg
os-prober


echo "FONT=ter-p24n
FONT_MAP=8859-2" >> /etc/vconsole.conf

systemctl enable NetworkManager

echo "all done. you SHOULD be able to reboot now."

