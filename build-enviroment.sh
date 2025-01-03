read -p "Do you want to remove old chroot ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    sudo umount /var/chroot
    sudo rm -rf /var/chroot
else
    echo "Continue."
fi

read -p "Do you want to install chroot ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    sudo pacman -S arch-install-scripts --noconfirm --needed
    sudo mkdir /var/chroot
    sudo pacstrap -K /var/chroot base base-devel
else
    echo "Continue."
fi

read -p "Do you want to fix chroot mount ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    sudo mount --bind /var/chroot /var/chroot
else
    echo "Continue."
fi

read -p "Do you want to add user in chroot ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee -a /var/chroot/etc/sudoers
    sudo arch-chroot /var/chroot useradd -m -G wheel -s /bin/bash timw
else
    echo "Continue."
fi

read -p "Do you want to edit chroot repo ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    sudo arch-chroot /var/chroot sudo sed -i '/# after the header, and they will be used before the default mirrors./a\Include = /etc/pacman.d/mirrorlist' /etc/pacman.conf
    sudo arch-chroot /var/chroot sudo sed -i '/# after the header, and they will be used before the default mirrors./a\[multilib]' /etc/pacman.conf
    sudo arch-chroot /var/chroot sudo sed -i '/# after the header, and they will be used before the default mirrors./a\Include = /etc/pacman.d/mirrorlist' /etc/pacman.conf
    sudo arch-chroot /var/chroot sudo sed -i '/# after the header, and they will be used before the default mirrors./a\[multilib-testing]' /etc/pacman.conf
    sudo arch-chroot /var/chroot sudo sed -i '/# after the header, and they will be used before the default mirrors./a\Include = /etc/pacman.d/mirrorlist' /etc/pacman.conf
    sudo arch-chroot /var/chroot sudo sed -i '/# after the header, and they will be used before the default mirrors./a\[extra-testing]' /etc/pacman.conf
    sudo arch-chroot /var/chroot sudo sed -i '/# after the header, and they will be used before the default mirrors./a\Include = /etc/pacman.d/mirrorlist' /etc/pacman.conf
    sudo arch-chroot /var/chroot sudo sed -i '/# after the header, and they will be used before the default mirrors./a\[core-testing]' /etc/pacman.conf
    sudo arch-chroot /var/chroot pacman -Syu nano git wget --noconfirm --needed
else
    echo "Continue."
fi

read -p "Do you want to enter chroot ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    sudo arch-chroot /var/chroot su -l timw
else
    echo "Continue."
fi
