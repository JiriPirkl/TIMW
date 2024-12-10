#!/bin/bash
sudo cp /etc/sudoers /etc/sudoers.bak
echo "Defaults timestamp_timeout=-1" | sudo tee -a /etc/sudoers > /dev/null

read -p "Enter your username: " username
echo "Hello, $username!"

read -p "Do you want to install build-enviroment [ need only once ] ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    echo "Continue."
    sudo pacman -Syu devtools --noconfirm --needed
    sudo rm -rf /home/$username/chroot
    mkdir -p /home/$username/chroot
    mkarchroot /home/$username/chroot/root base-devel
    arch-nspawn /home/$username/chroot/root pacman -Syu --noconfirm
    sudo sed -i '/# after the header, and they will be used before the default mirrors./a\Include = /etc/pacman.d/mirrorlist' /home/$username/chroot/root/etc/pacman.conf
    sudo sed -i '/# after the header, and they will be used before the default mirrors./a\[multilib]' /home/$username/chroot/root/etc/pacman.conf
    sudo sed -i '/# after the header, and they will be used before the default mirrors./a\Include = /etc/pacman.d/mirrorlist' /home/$username/chroot/root/etc/pacman.conf
    sudo sed -i '/# after the header, and they will be used before the default mirrors./a\[multilib-testing]' /home/$username/chroot/root/etc/pacman.conf
    sudo sed -i '/# after the header, and they will be used before the default mirrors./a\Include = /etc/pacman.d/mirrorlist' /home/$username/chroot/root/etc/pacman.conf
    sudo sed -i '/# after the header, and they will be used before the default mirrors./a\[extra-testing]' /home/$username/chroot/root/etc/pacman.conf
    sudo sed -i '/# after the header, and they will be used before the default mirrors./a\Include = /etc/pacman.d/mirrorlist' /home/$username/chroot/root/etc/pacman.conf
    sudo sed -i '/# after the header, and they will be used before the default mirrors./a\[core-testing]' /home/$username/chroot/root/etc/pacman.conf
    arch-nspawn /home/$username/chroot/root pacman -Syu --noconfirm
elif [[ "$answer" =~ ^[Nn] ]]; then
    echo "Continue."
else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi

read -p "Do you want to download sources ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    echo "Continue."
    rm -rf /home/$username/TIMW-AUR/sources
    mkdir -p /home/$username/TIMW-AUR/sources
    mkdir -p /home/$username/TIMW-AUR/x86_64
    cd /home/$username/TIMW-AUR/sources
    git clone https://aur.archlinux.org/directx-headers-git.git
    echo "options=(!lto)" >> /home/$username/TIMW-AUR/sources/directx-headers-git/PKGBUILD
    git clone https://aur.archlinux.org/mesa-git.git
    git clone https://aur.archlinux.org/lib32-mesa-git.git
    git clone https://aur.archlinux.org/wine-staging-wow64-git.git
    git clone https://aur.archlinux.org/dxvk-mingw.git
    sed -i 's/dxvk.git#tag=v\$pkgver/dxvk.git/g' /home/$username/TIMW-AUR/sources/dxvk-mingw/PKGBUILD
    echo "pkgver() {" >> /home/$username/TIMW-AUR/sources/dxvk-mingw/PKGBUILD
    echo "    cd dxvk" >> /home/$username/TIMW-AUR/sources/dxvk-mingw/PKGBUILD
    echo "    git describe --long --tags | sed 's/\([^-]*-g\)/r\1/;s/-/./g;s/v//g'" >> /home/$username/TIMW-AUR/sources/dxvk-mingw/PKGBUILD
    echo "}" >> /home/$username/TIMW-AUR/sources/dxvk-mingw/PKGBUILD
    git clone https://aur.archlinux.org/mingw-w64-tools.git
    git clone https://aur.archlinux.org/vkd3d-proton-mingw-git.git
    git clone https://aur.archlinux.org/kodi-git.git
    git clone https://aur.archlinux.org/lact-git.git
    git clone https://aur.archlinux.org/librewolf-bin.git
elif [[ "$answer" =~ ^[Nn] ]]; then
    echo "Continue."
else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi

read -p "Do you want to install mesa-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    echo "Continue."
    arch-nspawn /home/$username/chroot/root pacman -Syu --noconfirm
    cd /home/$username/TIMW-AUR/sources/directx-headers-git
    makechrootpkg -c -r /home/$username/chroot/ -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/directx-headers-git/directx-headers-git*.pkg.tar.zst /home/$username/TIMW-AUR/sources/mesa-git/
    cd /home/$username/TIMW-AUR/sources/mesa-git/
    makechrootpkg -c -r /home/$username/chroot/ -I directx-headers-git*.pkg.tar.zst -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/mesa-git/directx-headers-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/
    mv /home/$username/TIMW-AUR/sources/mesa-git/mesa-git*.pkg.tar.zst /home/$username/TIMW-AUR/sources/lib32-mesa-git/
    cd /home/$username/TIMW-AUR/sources/lib32-mesa-git/
    makechrootpkg -c -r /home/$username/chroot/ -I mesa-git*.pkg.tar.zst -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/lib32-mesa-git/mesa-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64 ; mv /home/$username/TIMW-AUR/sources/lib32-mesa-git/lib32-mesa-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64
elif [[ "$answer" =~ ^[Nn] ]]; then
    echo "Continue."
else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi

read -p "Do you want to install wine-staging-wow64-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    echo "Continue."
    arch-nspawn /home/$username/chroot/root pacman -Syu --noconfirm
    cd /home/$username/TIMW-AUR/sources/wine-staging-wow64-git
    makechrootpkg -c -r /home/$username/chroot/ -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/wine-staging-wow64-git/wine-staging-wow64-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/
elif [[ "$answer" =~ ^[Nn] ]]; then
    echo "Continue."
else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi

read -p "Do you want to install dxvk/vkd3d-proton ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    echo "Continue."
    arch-nspawn /home/$username/chroot/root pacman -Syu --noconfirm
    cd /home/$username/TIMW-AUR/sources/dxvk-mingw
    makechrootpkg -c -r /home/$username/chroot/ -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/dxvk-mingw/dxvk-mingw*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/
    cd /home/$username/TIMW-AUR/sources/mingw-w64-tools
    makechrootpkg -c -r /home/$username/chroot/ -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/mingw-w64-tools/mingw-w64-tools*.pkg.tar.zst /home/$username/TIMW-AUR/sources/vkd3d-proton-mingw-git
    cd /home/$username/TIMW-AUR/sources/vkd3d-proton-mingw-git
    makechrootpkg -c -r /home/$username/chroot/ -I mingw-w64-tools*.pkg.tar.zst -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/vkd3d-proton-mingw-git/mingw-w64-tools*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/ ; mv /home/$username/TIMW-AUR/sources/vkd3d-proton-mingw-git/vkd3d-proton-mingw-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/
elif [[ "$answer" =~ ^[Nn] ]]; then
    echo "Continue."
else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi

read -p "Do you want to install kodi-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    echo "Continue."
    arch-nspawn /home/$username/chroot/root pacman -Syu --noconfirm
    cd /home/$username/TIMW-AUR/sources/kodi-git
    makechrootpkg -c -r /home/$username/chroot/ -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/kodi-git/kodi-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/
elif [[ "$answer" =~ ^[Nn] ]]; then
    echo "Continue."
else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi

read -p "Do you want to install lact-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    echo "Continue."
    arch-nspawn /home/$username/chroot/root pacman -Syu --noconfirm
    cd /home/$username/TIMW-AUR/sources/lact-git
    makechrootpkg -c -r /home/$username/chroot/ -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/lact-git/lact-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/
elif [[ "$answer" =~ ^[Nn] ]]; then
    echo "Continue."
else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi

read -p "Do you want to install librewolf-bin ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    echo "Continue."
    arch-nspawn /home/$username/chroot/root pacman -Syu --noconfirm
    cd /home/$username/TIMW-AUR/sources/librewolf-bin
    makechrootpkg -c -r /home/$username/chroot/ -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/librewolf-bin/librewolf-bin*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/
elif [[ "$answer" =~ ^[Nn] ]]; then
    echo "Continue."
else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi

sudo cp /etc/sudoers.bak /etc/sudoers
