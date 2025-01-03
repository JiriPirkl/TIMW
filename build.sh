#!/bin/bash
read -p "Enter your username: " username
SOURCE_DIR="/home/$username/TIMW/TIMW-AUR"
DEST_DIR="/home/$username/TIMW-AUR"

if [ ! -d "$DEST_DIR" ]; then
    cp -r "$SOURCE_DIR" "$DEST_DIR"
else
    echo "Continue."
fi

sudo pacman -Syu --noconfirm --needed
sh /home/$username/TIMW-AUR/sources/LLVM/rustup-init.sh
. "$HOME/.cargo/env"

read -p "Do you want to build llvm-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    cd /home/$username/TIMW-AUR/sources/LLVM/python-recommonmark
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/LLVM/python-recommonmark/python-recommonmark*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64
    cd /home/$username/TIMW-AUR/sources/LLVM/llvm-git
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -Rs llvm compiler-rt clang lldb lld llvm-libs --noconfirm
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/LLVM/llvm-git/*llvm*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64
    cd /home/$username/TIMW-AUR/sources/LLVM/lib32-llvm-git
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/LLVM/lib32-llvm-git/*llvm*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64
    cd /home/$username/TIMW-AUR/sources/LLVM/spirv-tools-git
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/LLVM/spirv-tools-git/spirv-tools-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64
    cd /home/$username/TIMW-AUR/sources/LLVM/spirv-headers-git
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/LLVM/spirv-headers-git/spirv-headers-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64
    cd /home/$username/TIMW-AUR/sources/LLVM/spirv-llvm-translator-git
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/LLVM/spirv-llvm-translator-git/spirv-llvm-translator-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64
    cd /home/$username/TIMW-AUR/sources/LLVM/lib32-spirv-tools-git
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/LLVM/lib32-spirv-tools-git/lib32-spirv-tools-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64
    cd /home/$username/TIMW-AUR/sources/LLVM/lib32-spirv-llvm-translator-git
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/LLVM/lib32-spirv-llvm-translator-git/lib32-spirv-llvm-translator-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64
else
    echo "Continue."
fi

read -p "Do you want to build mesa-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    cd /home/$username/TIMW-AUR/sources/directx-headers-git
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/directx-headers-git/directx-headers-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64
    cd /home/$username/TIMW-AUR/sources/mesa-git/
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/mesa-git/mesa-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64
    cd /home/$username/TIMW-AUR/sources/lib32-mesa-git/
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/lib32-mesa-git/lib32-mesa-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64
else
    echo "Continue."
fi

read -p "Do you want to build wine-staging-wow64-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    cd /home/$username/TIMW-AUR/sources/wine-staging-wow64-git
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/wine-staging-wow64-git/wine-staging-wow64-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/
else
    echo "Continue."
fi

read -p "Do you want to build dxvk/vkd3d-proton ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    cd /home/$username/TIMW-AUR/sources/dxvk-mingw
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/dxvk-mingw/dxvk-mingw*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/
    cd /home/$username/TIMW-AUR/sources/mingw-w64-tools
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/mingw-w64-tools/mingw-w64-tools*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/
    cd /home/$username/TIMW-AUR/sources/vkd3d-proton-mingw-git
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/vkd3d-proton-mingw-git/vkd3d-proton-mingw-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/
else
    echo "Continue."
fi

read -p "Do you want to build kodi-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    cd /home/$username/TIMW-AUR/sources/kodi-git
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    rm -rf *debug*.pkg.tar.zst ; rm -rf kodi-git-dev*.pkg.tar.zst ; rm -rf kodi-git-eventclient*.pkg.tar.zst ; rm -rf kodi-git-tools-texturepacker*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/kodi-git/kodi-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/
else
    echo "Continue."
fi

read -p "Do you want to build lact-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    cd /home/$username/TIMW-AUR/sources/lact-git
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/lact-git/lact-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/
else
    echo "Continue."
fi

read -p "Do you want to build librewolf-bin ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    cd /home/$username/TIMW-AUR/sources/librewolf-bin
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/librewolf-bin/librewolf-bin*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/
else
    echo "Continue."
fi

read -p "Do you want to build cosmic-app-library-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-app-library-git
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-app-library-git/cosmic-app-library-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic
else
    echo "Continue."
fi

read -p "Do you want to build cosmic-icons-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    cd /home/$username/TIMW-AUR/sources/cosmic/pop-icon-theme-git
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/cosmic/pop-icon-theme-git/pop-icon-theme-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-icons-git
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-icons-git/cosmic-icons-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Continue."
fi

read -p "Do you want to build cosmic-applets-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-applets-git
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-applets-git/cosmic-applets-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Continue."
fi

read -p "Do you want to build cosmic-bg-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-bg-git
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-bg-git/cosmic-bg-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Continue."
fi

read -p "Do you want to build cosmic-comp-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-comp-git
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-comp-git/cosmic-comp-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Continue."
fi

read -p "Do you want to build cosmic-files-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-files-git
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-files-git/cosmic-files-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Continue."
fi

read -p "Do you want to build cosmic-greeter-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-greeter-git
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-greeter-git/cosmic-greeter-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Continue."
fi

read -p "Do you want to build cosmic-idle-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-idle-git
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-idle-git/cosmic-idle-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Continue."
fi

read -p "Do you want to build cosmic-launcher-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    cd /home/$username/TIMW-AUR/sources/cosmic/pop-launcher-git
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/cosmic/pop-launcher-git/pop-launcher-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-launcher-git
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-launcher-git/cosmic-launcher-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Continue."
fi

read -p "Do you want to build cosmic-notifications-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-notifications-git
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-notifications-git/cosmic-notifications-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Continue."
fi

read -p "Do you want to build cosmic-osd-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-osd-git
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-osd-git/cosmic-osd-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Continue."
fi

read -p "Do you want to build cosmic-panel-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-panel-git
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-panel-git/cosmic-panel-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Continue."
fi

read -p "Do you want to build cosmic-randr-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-randr-git
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-randr-git/cosmic-randr-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/

else
    echo "Continue."
fi

read -p "Do you want to build xdg-desktop-portal-cosmic-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    cd /home/$username/TIMW-AUR/sources/cosmic/xdg-desktop-portal-cosmic-git
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/cosmic/xdg-desktop-portal-cosmic-git/xdg-desktop-portal-cosmic-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Continue."
fi

read -p "Do you want to build cosmic-screenshot-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-screenshot-git
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-screenshot-git/cosmic-screenshot-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Continue."
fi

read -p "Do you want to build cosmic-settings-daemon-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    cd /home/$username/TIMW-AUR/sources/cosmic/pop-sound-theme-git
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/cosmic/pop-sound-theme-git/pop-sound-theme-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-settings-daemon-git
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-settings-daemon-git/cosmic-settings-daemon-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Continue."
fi

read -p "Do you want to build cosmic-settings-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-settings-git
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-settings-git/cosmic-settings-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Continue."
fi

read -p "Do you want to build cosmic-workspaces-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-workspaces-git
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-workspaces-git/cosmic-workspaces-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Continue."
fi

read -p "Do you want to build cosmic-session-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-session-git
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-session-git/*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Continue."
fi

read -p "Do you want to build cosmic-term-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-term-git
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-term-git/cosmic-term-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Continue."
fi

read -p "Do you want to build cosmic-edit-git ? (yes/no): " answer
if [[ "$answer" =~ ^[Yy] ]]; then
    cd /home/$username/TIMW-AUR/sources/cosmic/cosmic-edit-git
    makepkg -s --skipinteg --noconfirm --needed
    rm -rf *debug*.pkg.tar.zst
    sudo pacman -U *.pkg.tar.zst --noconfirm --needed
    mv /home/$username/TIMW-AUR/sources/cosmic/cosmic-edit-git/cosmic-edit-git*.pkg.tar.zst /home/$username/TIMW-AUR/x86_64/cosmic/
else
    echo "Continue."
fi
