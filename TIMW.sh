#!/bin/bash

# Remove old TIMW definitions and alias
sed -i '/^TIMW()/,/^}/d;/alias timw=TIMW/d' "$HOME/.bashrc"

cat >> "$HOME/.bashrc" << 'EOF'
TIMW() {
  sudo -v; while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
  systemctl --user daemon-reload
  systemctl --user is-active --quiet timw-http-server.service || systemctl --user start timw-http-server.service

  TIMW_PKGS=$(pacman -Sl TIMW-AUR | awk '{print $2}')
  USER_HOME=$(eval echo "~$SUDO_USER")
  CHROOT="$USER_HOME/chroot"
  TIMW_SERVICE="$HOME/.config/systemd/user/timw-http-server.service"

  main_menu() {
    clear
    echo "===== TIMW Main Menu ====="
    echo "1) Install"
    echo "2) Install Packages"
    echo "3) Build Packages"
    echo "0) Exit"
    read -rp "Select an option: " opt
    case $opt in
      1) menu_install ;;
      2) install_packages_menu ;;
      3) build_packages_menu ;;
      0) return ;;
      *) echo "Invalid choice"; sleep 1 ;;
    esac
    main_menu
  }

  install_packages_menu() {
    clear
    echo "===== Install Packages ====="
    echo "1) Install package"
    echo "2) Install TIMW-AUR packages"
    echo "0) Back"
    read -rp "Select: " opt
    case $opt in
      1) menu_pkg install ;;
      2) menu_timw_aur install ;;
      0) return ;;
      *) echo "Invalid choice"; sleep 1 ;;
    esac
    install_packages_menu
  }

  build_packages_menu() {
    clear
    echo "===== Build Packages ====="
    echo "1) Build package"
    echo "2) Build TIMW-AUR packages"
    echo "0) Back"
    read -rp "Select: " opt
    case $opt in
      1) menu_pkg build ;;
      2) menu_timw_aur build ;;
      0) return ;;
      *) echo "Invalid choice"; sleep 1 ;;
    esac
    build_packages_menu
  }

  menu_install() {
    clear; echo "===== Install ====="
    echo "1) Run installation"
    echo "2) Install chroot"
    echo "3) Enter chroot"
    echo "0) Back"
    read -rp "Select: " c
    case $c in
      1)
        declare -A files=(
          [makepkg.conf]=makepkg.conf
          [makepkg.conf.d/rust.conf]=rust.conf
          [pacman.conf]=pacman.conf
          [pacman.d/timw-mirrorlist]=timw-mirrorlist
        )
        for f in "${!files[@]}"; do
          sudo mkdir -p "/etc/$(dirname "$f")"
          sudo curl -fsSL "https://raw.githubusercontent.com/JiriPirkl/TIMW/main/${files[$f]}" -o "/etc/$f"
        done
        sudo mkdir -p "$CHROOT" /mnt/localrepo && sudo chmod 777 /mnt/localrepo
        mkdir -p "$(dirname "$TIMW_SERVICE")"
        [[ -f "$TIMW_SERVICE" ]] || cat > "$TIMW_SERVICE" << 'S'
[Unit]
Description=TIMW HTTP Server
After=network.target
[Service]
WorkingDirectory=/mnt/localrepo
ExecStart=/usr/bin/python3 -m http.server 8000
Restart=always
RestartSec=5
[Install]
WantedBy=default.target
S
        ;;
      2)
        sudo pacman -Syu devtools --needed
        sudo rm -rf "$CHROOT/root" "$CHROOT/root.lock"
        mkarchroot "$CHROOT/root" base-devel
        declare -A files=(
          [makepkg.conf]=makepkg.conf
          [makepkg.conf.d/rust.conf]=rust.conf
          [pacman.conf]=pacman.conf
          [pacman.d/timw-mirrorlist]=timw-mirrorlist
        )
        for f in "${!files[@]}"; do
          sudo mkdir -p "$CHROOT/root/etc/$(dirname "$f")"
          sudo curl -fsSL "https://raw.githubusercontent.com/JiriPirkl/TIMW/main/${files[$f]}" -o "$CHROOT/root/etc/$f"
        done
        ;;
      3) arch-nspawn "$CHROOT/root" ;;
      0) return ;;
      *) echo "Invalid choice"; sleep 1 ;;
    esac
    menu_install
  }

  menu_pkg() {
    op=$1
    clear; echo "===== ${op^} Package ====="
    echo "1) In chroot"; echo "2) Local"; echo "0) Back"
    read -rp "Select: " c
    case $c in
      1)
        if [[ $op == install ]]; then
          read -rp "Package name(s): " pkg
          [[ -n "$pkg" ]] && arch-nspawn "$CHROOT/root" pacman -Syu $pkg
        else
          read -e -p "Directory with PKGBUILD: " dir
          [[ -d "$dir" ]] && cd "$dir" && makechrootpkg -c -r "$CHROOT" -- --skipinteg && mv *.pkg.tar.zst /mnt/localrepo && cd /mnt/localrepo && repo-add TIMW-AUR.db.tar.gz *.pkg.tar.zst && systemctl --user restart timw-http-server.service && arch-nspawn "$CHROOT/root" pacman -Syu
        fi
        ;;
      2)
        if [[ $op == install ]]; then
          read -rp "Package name(s): " pkg
          [[ -n "$pkg" ]] && sudo pacman -Syu $pkg
        else
          read -e -p "Directory with PKGBUILD: " dir
          [[ -d "$dir" ]] && cd "$dir" && makepkg -src --skipinteg && mv *.pkg.tar.zst /mnt/localrepo && cd /mnt/localrepo && repo-add TIMW-AUR.db.tar.gz *.pkg.tar.zst && systemctl --user restart timw-http-server.service && sudo pacman -Syu
        fi
        ;;
      0) return ;;
      *) echo "Invalid choice"; sleep 1 ;;
    esac
    menu_pkg $op
  }

  menu_timw_aur() {
    op=$1
    clear; echo "===== ${op^} TIMW-AUR ====="
    echo "1) In chroot"; echo "2) Local"; echo "0) Back"
    read -rp "Select: " c
    case $c in
      1) menu_timw_aur_pkgs "arch-nspawn \"$CHROOT/root\" pacman -Syu" "$op" ;;
      2) menu_timw_aur_pkgs "sudo pacman -Syu" "$op" ;;
      0) return ;;
      *) echo "Invalid choice"; sleep 1 ;;
    esac
    menu_timw_aur $op
  }

  menu_timw_aur_pkgs() {
    cmd="$1"; op="$2"
    while true; do
      clear
      echo "===== TIMW-AUR ====="
      echo "0) Back"; echo "a) All packages"
      i=1; for pkg in $TIMW_PKGS; do echo "$i) $pkg"; ((i++)); done
      read -rp "Select package(s) (semicolon-separated): " sel
      [[ $sel == "0" ]] && return
      [[ $sel == "a" ]] && { 
        if [[ $op == install ]]; then eval "$cmd \$TIMW_PKGS --needed"; 
        else
          for pkg in $TIMW_PKGS; do eval "$cmd $pkg --needed"; done
        fi
      }
      [[ $sel != "0" && $sel != "a" ]] && IFS=';' read -ra s <<< "$sel"; for n in "${s[@]}"; do
        n=$(echo "$n" | xargs)
        [[ $n =~ ^[0-9]+$ ]] && (( n >= 1 && n <= $(echo $TIMW_PKGS | wc -w) )) && pkg=$(echo $TIMW_PKGS | cut -d' ' -f$n)
        if [[ $op == install ]]; then eval "$cmd \$pkg --needed"; else eval "$cmd $pkg --needed"; fi
      done
    done
  }

  main_menu
}
EOF

echo "alias timw=TIMW" >> "$HOME/.bashrc"
source "$HOME/.bashrc"
