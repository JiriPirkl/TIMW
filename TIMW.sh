#!/bin/bash
sudo cp /etc/sudoers /etc/sudoers.bak
echo "Defaults timestamp_timeout=-1" | sudo tee -a /etc/sudoers > /dev/null

read -p "Enter your username: " username
echo "Hello, $username!"

read -p "Do you want to install build-enviroment [ need only once ] ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
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
else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi

read -p "Do you want to download sources ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    rm -rf /home/$username/TIMW-AUR/sources
    mkdir -p /home/$username/TIMW-AUR/sources/cosmic
    rm -rf /home/$username/TIMW-AUR/x86_64/
    mkdir -p /home/$username/TIMW-AUR/x86_64/cosmic
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
    cd /home/$username/TIMW-AUR/sources/cosmic
    git clone https://aur.archlinux.org/cosmic-app-library-git.git
    git clone https://aur.archlinux.org/cosmic-applets-git.git
    git clone https://aur.archlinux.org/cosmic-icons-git.git
    git clone https://aur.archlinux.org/pop-icon-theme-git.git
    git clone https://aur.archlinux.org/cosmic-bg-git.git
    git clone https://aur.archlinux.org/cosmic-comp-git.git
    git clone https://aur.archlinux.org/cosmic-files-git.git
    git clone https://aur.archlinux.org/cosmic-greeter-git.git
    git clone https://aur.archlinux.org/cosmic-idle-git.git
    git clone https://aur.archlinux.org/cosmic-launcher-git.git
    git clone https://aur.archlinux.org/cosmic-notifications-git.git
    git clone https://aur.archlinux.org/cosmic-osd-git.git
    git clone https://aur.archlinux.org/cosmic-panel-git.git
    git clone https://aur.archlinux.org/cosmic-randr-git.git
    git clone https://aur.archlinux.org/cosmic-screenshot-git.git
    git clone https://aur.archlinux.org/xdg-desktop-portal-cosmic-git.git
    git clone https://aur.archlinux.org/cosmic-settings-daemon-git.git
    git clone https://aur.archlinux.org/pop-sound-theme-git.git
    git clone https://aur.archlinux.org/cosmic-settings-git.git
    git clone https://aur.archlinux.org/cosmic-workspaces-git.git
    git clone https://aur.archlinux.org/cosmic-edit-git.git
    git clone https://aur.archlinux.org/cosmic-term-git.git
    git clone https://aur.archlinux.org/cosmic-session-git.git
    git clone https://aur.archlinux.org/pop-launcher-git.git
else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi

read -p "Do you want to install mesa-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    arch-nspawn /home/$username/chroot/root pacman -Syu --noconfirm
    cd /home/$username/TIMW-AUR/sources/directx-headers-git
    makechrootpkg -c -r /home/$username/chroot/ -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/directx-headers-git/directx-headers-git*.pkg.tar.zst /home/$username/TIMW-AUR/sources/mesa-git/
    cd /home/$username/TIMW-AUR/sources/mesa-git/
    makechrootpkg -c -r /home/$username/chroot/ -I directx-headers-git*.pkg.tar.zst -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/mesa-git/directx-headers-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/ ; mv /home/$username/TIMW-AUR/sources/mesa-git/mesa-git*.pkg.tar.zst /home/$username/TIMW-AUR/sources/lib32-mesa-git/
    cd /home/$username/TIMW-AUR/sources/lib32-mesa-git/
    makechrootpkg -c -r /home/$username/chroot/ -I mesa-git*.pkg.tar.zst -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/lib32-mesa-git/mesa-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64 ; mv /home/$username/TIMW-AUR/sources/lib32-mesa-git/lib32-mesa-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64
else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi

read -p "Do you want to install wine-staging-wow64-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    arch-nspawn /home/$username/chroot/root pacman -Syu --noconfirm
    cd /home/$username/TIMW-AUR/sources/wine-staging-wow64-git
    makechrootpkg -c -r /home/$username/chroot/ -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/wine-staging-wow64-git/wine-staging-wow64-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/
else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi

read -p "Do you want to install dxvk/vkd3d-proton ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
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
else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi

read -p "Do you want to install kodi-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    arch-nspawn /home/$username/chroot/root pacman -Syu --noconfirm
    cd /home/$username/TIMW-AUR/sources/kodi-git
    makechrootpkg -c -r /home/$username/chroot/ -- --skipinteg
    rm -rf *debug*.pkg.tar.zst ; rm -rf kodi-git-dev*.pkg.tar.zst ; rm -rf kodi-git-eventclient*.pkg.tar.zst ; rm -rf kodi-git-tools-texturepacker*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/kodi-git/kodi-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/
else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi

read -p "Do you want to install lact-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    arch-nspawn /home/$username/chroot/root pacman -Syu --noconfirm
    cd /home/$username/TIMW-AUR/sources/lact-git
    makechrootpkg -c -r /home/$username/chroot/ -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/lact-git/lact-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/
else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi

read -p "Do you want to install librewolf-bin ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    arch-nspawn /home/$username/chroot/root pacman -Syu --noconfirm
    cd /home/$username/TIMW-AUR/sources/librewolf-bin
    makechrootpkg -c -r /home/$username/chroot/ -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/librewolf-bin/librewolf-bin*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/
else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi

read -p "Do you want to install cosmic-app-library-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    arch-nspawn /home/$username/chroot/root pacman -Syu --noconfirm
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-app-library-git
    makechrootpkg -c -r /home/$username/chroot/ -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-app-library-git/cosmic-app-library-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic
else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi

read -p "Do you want to install cosmic-icons-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    arch-nspawn /home/$username/chroot/root pacman -Syu --noconfirm
    cd /home/$username/TIMW-AUR/sources/cosmic/pop-icon-theme-git
    makechrootpkg -c -r /home/$username/chroot/ -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/cosmic/pop-icon-theme-git/pop-icon-theme-git*.pkg.tar.zst /home/$username/TIMW-AUR/sources/cosmic/cosmic-icons-git
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-icons-git
    makechrootpkg -c -r /home/$username/chroot/ -I pop-icon-theme-git*.pkg.tar.zst -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-icons-git/pop-icon-theme-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/ ; mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-icons-git/cosmic-icons-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi

read -p "Do you want to install cosmic-applets-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    arch-nspawn /home/$username/chroot/root pacman -Syu --noconfirm
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-applets-git
    mv /home/$username/TIMW-AUR/x86_64/cosmic/pop-icon-theme-git*.pkg.tar.zst /home/$username/TIMW-AUR/sources/cosmic/cosmic-applets-git ; mv /home/$username/TIMW-AUR/x86_64/cosmic/cosmic-icons-git*.pkg.tar.zst /home/$username/TIMW-AUR/sources/cosmic/cosmic-applets-git
    makechrootpkg -c -r /home/$username/chroot/ -I pop-icon-theme-git*.pkg.tar.zst -I cosmic-icons-git*.pkg.tar.zst -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-applets-git/pop-icon-theme-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/ ; mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-applets-git/cosmic-icons-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/ ; mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-applets-git/cosmic-applets-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi

read -p "Do you want to install cosmic-bg-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    arch-nspawn /home/$username/chroot/root pacman -Syu --noconfirm
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-bg-git
    makechrootpkg -c -r /home/$username/chroot/ -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-bg-git/cosmic-bg-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi

read -p "Do you want to install cosmic-comp-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    arch-nspawn /home/$username/chroot/root pacman -Syu --noconfirm
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-comp-git
    makechrootpkg -c -r /home/$username/chroot/ -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-comp-git/cosmic-comp-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi

read -p "Do you want to install cosmic-files-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    arch-nspawn /home/$username/chroot/root pacman -Syu --noconfirm
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-files-git
    makechrootpkg -c -r /home/$username/chroot/ -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-files-git/cosmic-files-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi

read -p "Do you want to install cosmic-greeter-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    arch-nspawn /home/$username/chroot/root pacman -Syu --noconfirm
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-greeter-git
    mv /home/$username/TIMW-AUR/x86_64/cosmic/cosmic-comp-git*.pkg.tar.zst /home/$username/TIMW-AUR/sources/cosmic/cosmic-greeter-git
    makechrootpkg -c -r /home/$username/chroot/ -I cosmic-comp-git*.pkg.tar.zst -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-greeter-git/cosmic-comp-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/ ; mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-greeter-git/cosmic-greeter-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi

read -p "Do you want to install cosmic-idle-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    arch-nspawn /home/$username/chroot/root pacman -Syu --noconfirm
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-idle-git
    makechrootpkg -c -r /home/$username/chroot/ -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-idle-git/cosmic-idle-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi

read -p "Do you want to install cosmic-launcher-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    arch-nspawn /home/$username/chroot/root pacman -Syu --noconfirm
    cd /home/$username/TIMW-AUR/sources/cosmic/pop-launcher-git
    mv /home/$username/TIMW-AUR/x86_64/cosmic/pop-icon-theme-git*.pkg.tar.zst /home/$username/TIMW-AUR/sources/cosmic/pop-launcher-git
    makechrootpkg -c -r /home/$username/chroot/ -I pop-icon-theme-git*.pkg.tar.zst -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/cosmic/pop-launcher-git/pop-launcher-git*.pkg.tar.zst /home/$username/TIMW-AUR/sources/cosmic/cosmic-launcher-git ; mv /home/$username/TIMW-AUR/sources/cosmic/pop-launcher-git/pop-icon-theme-git*.pkg.tar.zst /home/$username/TIMW-AUR/sources/cosmic/cosmic-launcher-git
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-launcher-git
    makechrootpkg -c -r /home/$username/chroot/ -I pop-icon-theme-git*.pkg.tar.zst -I pop-launcher-git*.pkg.tar.zst -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-launcher-git/pop-launcher-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/ ; mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-launcher-git/cosmic-launcher-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/ ; mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-launcher-git/pop-icon-theme-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi

read -p "Do you want to install cosmic-notifications-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    arch-nspawn /home/$username/chroot/root pacman -Syu --noconfirm
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-notifications-git
    makechrootpkg -c -r /home/$username/chroot/ -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-notifications-git/cosmic-notifications-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi

read -p "Do you want to install cosmic-osd-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    arch-nspawn /home/$username/chroot/root pacman -Syu --noconfirm
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-osd-git
    makechrootpkg -c -r /home/$username/chroot/ -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-osd-git/cosmic-osd-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi

read -p "Do you want to install cosmic-panel-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    arch-nspawn /home/$username/chroot/root pacman -Syu --noconfirm
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-panel-git
    makechrootpkg -c -r /home/$username/chroot/ -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-panel-git/cosmic-panel-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi

read -p "Do you want to install cosmic-randr-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then

    arch-nspawn /home/$username/chroot/root pacman -Syu --noconfirm
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-randr-git
    makechrootpkg -c -r /home/$username/chroot/ -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-randr-git/cosmic-randr-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/

else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi

read -p "Do you want to install xdg-desktop-portal-cosmic-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    arch-nspawn /home/$username/chroot/root pacman -Syu --noconfirm
    cd /home/$username/TIMW-AUR/sources/cosmic/xdg-desktop-portal-cosmic-git
    makechrootpkg -c -r /home/$username/chroot/ -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/cosmic/xdg-desktop-portal-cosmic-git/xdg-desktop-portal-cosmic-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi

read -p "Do you want to install cosmic-screenshot-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    arch-nspawn /home/$username/chroot/root pacman -Syu --noconfirm
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-screenshot-git
    mv /home/$username/TIMW-AUR/x86_64/cosmic/xdg-desktop-portal-cosmic-git*.pkg.tar.zst /home/$username/TIMW-AUR/sources/cosmic/cosmic-screenshot-git
    makechrootpkg -c -r /home/$username/chroot/ -I xdg-desktop-portal-cosmic-git*.pkg.tar.zst -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-screenshot-git/xdg-desktop-portal-cosmic-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/ ; mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-screenshot-git/cosmic-screenshot-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi

read -p "Do you want to install cosmic-settings-daemon-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    arch-nspawn /home/$username/chroot/root pacman -Syu --noconfirm
    cd /home/$username/TIMW-AUR/sources/cosmic/pop-sound-theme-git
    makechrootpkg -c -r /home/$username/chroot/ -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/cosmic/pop-sound-theme-git/pop-sound-theme-git*.pkg.tar.zst /home/$username/TIMW-AUR/sources/cosmic/cosmic-settings-daemon-git
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-settings-daemon-git
    makechrootpkg -c -r /home/$username/chroot/ -I pop-sound-theme-git*.pkg.tar.zst -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-settings-daemon-git/pop-sound-theme-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/ ; mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-settings-daemon-git/cosmic-settings-daemon-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi

read -p "Do you want to install cosmic-settings-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    arch-nspawn /home/$username/chroot/root pacman -Syu --noconfirm
    mv /home/$username/TIMW-AUR/x86_64/cosmic/pop-icon-theme-git*.pkg.tar.zst /home/$username/TIMW-AUR/sources/cosmic/cosmic-settings-git ; mv /home/$username/TIMW-AUR/x86_64/cosmic/cosmic-icons-git*.pkg.tar.zst /home/$username/TIMW-AUR/sources/cosmic/cosmic-settings-git ; mv /home/$username/TIMW-AUR/x86_64/cosmic/cosmic-randr-git*.pkg.tar.zst /home/$username/TIMW-AUR/sources/cosmic/cosmic-settings-git
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-settings-git
    makechrootpkg -c -r /home/$username/chroot/ -I pop-icon-theme-git*.pkg.tar.zst -I cosmic-icons-git*.pkg.tar.zst -I cosmic-randr-git*.pkg.tar.zst -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-settings-git/pop-icon-theme-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/ ; mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-settings-git/cosmic-icons-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/ ; mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-settings-git/cosmic-randr-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/ ; mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-settings-git/cosmic-settings-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi

read -p "Do you want to install cosmic-workspaces-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    arch-nspawn /home/$username/chroot/root pacman -Syu --noconfirm
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-workspaces-git
    makechrootpkg -c -r /home/$username/chroot/ -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-workspaces-git/cosmic-workspaces-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi

read -p "Do you want to install cosmic-session-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    arch-nspawn /home/$username/chroot/root pacman -Syu --noconfirm
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-session-git
    mv /home/$username/TIMW-AUR/x86_64/cosmic/*.pkg.tar.zst /home/$username/TIMW-AUR/sources/cosmic/cosmic-session-git
    makechrootpkg -c -r /home/$username/chroot/ -I cosmic-app-library-git*.pkg.tar.zst -I pop-icon-theme-git*.pkg.tar.zst -I cosmic-icons-git*.pkg.tar.zst -I pop-icon-theme-git*.pkg.tar.zst -I cosmic-applets-git*.pkg.tar.zst -I cosmic-bg-git*.pkg.tar.zst -I cosmic-comp-git*.pkg.tar.zst -I cosmic-files-git*.pkg.tar.zst -I cosmic-files-git*.pkg.tar.zst -I cosmic-greeter-git*.pkg.tar.zst -I cosmic-idle-git*.pkg.tar.zst -I pop-launcher-git*.pkg.tar.zst -I cosmic-launcher-git*.pkg.tar.zst -I cosmic-notifications-git*.pkg.tar.zst -I cosmic-osd-git*.pkg.tar.zst -I cosmic-panel-git*.pkg.tar.zst -I cosmic-randr-git*.pkg.tar.zst -I xdg-desktop-portal-cosmic-git*.pkg.tar.zst -I cosmic-screenshot-git*.pkg.tar.zst -I pop-sound-theme-git*.pkg.tar.zst -I cosmic-settings-daemon-git*.pkg.tar.zst -I cosmic-settings-git*.pkg.tar.zst -I cosmic-workspaces-git*.pkg.tar.zst -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-session-git/*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi

read -p "Do you want to install cosmic-term-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    arch-nspawn /home/$username/chroot/root pacman -Syu --noconfirm
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-term-git
    mv /home/$username/TIMW-AUR/x86_64/cosmic/pop-icon-theme-git*.pkg.tar.zst /home/$username/TIMW-AUR/sources/cosmic/cosmic-term-git ; mv /home/$username/TIMW-AUR/x86_64/cosmic/cosmic-icons-git*.pkg.tar.zst /home/$username/TIMW-AUR/sources/cosmic/cosmic-term-git
    makechrootpkg -c -r /home/$username/chroot/ -I pop-icon-theme-git*.pkg.tar.zst -I cosmic-icons-git*.pkg.tar.zst -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-term-git/pop-icon-theme-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/ ; mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-term-git/cosmic-icons-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/ ; mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-term-git/cosmic-term-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi

read -p "Do you want to install cosmic-edit-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    arch-nspawn /home/$username/chroot/root pacman -Syu --noconfirm
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-edit-git
    mv /home/$username/TIMW-AUR/x86_64/cosmic/pop-icon-theme-git*.pkg.tar.zst /home/$username/TIMW-AUR/sources/cosmic/cosmic-edit-git ; mv /home/$username/TIMW-AUR/x86_64/cosmic/cosmic-icons-git*.pkg.tar.zst /home/$username/TIMW-AUR/sources/cosmic/cosmic-edit-git
    makechrootpkg -c -r /home/$username/chroot/ -I pop-icon-theme-git*.pkg.tar.zst -I cosmic-icons-git*.pkg.tar.zst -- --skipinteg
    rm -rf *debug*.pkg.tar.zst
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-edit-git/pop-icon-theme-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/ ; mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-edit-git/cosmic-icons-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/ ; mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-edit-git/cosmic-edit-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi

sudo cp /etc/sudoers.bak /etc/sudoers
