#install chroot
sudo umount /var/chroot
sudo rm -rf /var/chroot
sudo pacman -S arch-install-scripts --noconfirm --needed
sudo mkdir /var/chroot
sudo pacstrap -K /var/chroot base base-devel

#fix mount 
sudo mount --bind /var/chroot /var/chroot

#add user in chroot
echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee -a /var/chroot/etc/sudoers
sudo arch-chroot /var/chroot useradd -m -G wheel -s /bin/bash timw

#edit repo
sudo arch-chroot /var/chroot sudo sed -i '/# after the header, and they will be used before the default mirrors./a\Include = /etc/pacman.d/mirrorlist' /etc/pacman.conf
sudo arch-chroot /var/chroot sudo sed -i '/# after the header, and they will be used before the default mirrors./a\[multilib]' /etc/pacman.conf
sudo arch-chroot /var/chroot sudo sed -i '/# after the header, and they will be used before the default mirrors./a\Include = /etc/pacman.d/mirrorlist' /etc/pacman.conf
sudo arch-chroot /var/chroot sudo sed -i '/# after the header, and they will be used before the default mirrors./a\[multilib-testing]' /etc/pacman.conf
sudo arch-chroot /var/chroot sudo sed -i '/# after the header, and they will be used before the default mirrors./a\Include = /etc/pacman.d/mirrorlist' /etc/pacman.conf
sudo arch-chroot /var/chroot sudo sed -i '/# after the header, and they will be used before the default mirrors./a\[extra-testing]' /etc/pacman.conf
sudo arch-chroot /var/chroot sudo sed -i '/# after the header, and they will be used before the default mirrors./a\Include = /etc/pacman.d/mirrorlist' /etc/pacman.conf
sudo arch-chroot /var/chroot sudo sed -i '/# after the header, and they will be used before the default mirrors./a\[core-testing]' /etc/pacman.conf
sudo arch-chroot /var/chroot pacman -Syu nano git wget --noconfirm --needed

#enter chroot
sudo arch-chroot /var/chroot su -l timw
