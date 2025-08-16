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
    clear; echo "===== TIMW Main Menu ====="
    echo "1) Install"
    echo "2) Install package"
    echo "3) Install TIMW-AUR packages"
    echo "4) Build package"
    echo "5) Build TIMW-AUR packages"
    echo "0) Exit"
    read -rp "Select an option: " opt
    case $opt in
      1) menu_install ;;
      2) menu_pkg install ;;
      3) menu_timw_aur ;;
      4) menu_pkg build ;;
      5) menu_build_timw_aur ;;
      0) return ;;
      *) echo "Invalid choice"; sleep 1 ;;
    esac
    main_menu
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
          read -rp "Directory with PKGBUILD: " dir
          [[ -d "$dir" ]] && cd "$dir" && makepkg -src --skipinteg && mv *.pkg.tar.zst /mnt/localrepo && cd /mnt/localrepo && repo-add TIMW-AUR.db.tar.gz *.pkg.tar.zst && systemctl --user restart timw-http-server.service && sudo pacman -Syu
        fi
        ;;
      0) return ;;
      *) echo "Invalid choice"; sleep 1 ;;
    esac
    menu_pkg $op
  }

  menu_timw_aur() {
    clear; echo "===== Install TIMW-AUR ====="
    echo "1) In chroot"; echo "2) Local"; echo "0) Back"
    read -rp "Select: " c
    case $c in
      1) menu_timw_aur_pkgs "arch-nspawn \"$CHROOT/root\" pacman -Syu" ;;
      2) menu_timw_aur_pkgs "sudo pacman -Syu" ;;
      0) return ;;
      *) echo "Invalid choice"; sleep 1 ;;
    esac
    menu_timw_aur
  }

  menu_timw_aur_pkgs() {
    cmd="$1"; while true; do clear
      echo "===== TIMW-AUR ====="
      echo "0) Back"; echo "a) Install ALL packages"
      i=1; for pkg in $TIMW_PKGS; do echo "$i) $pkg"; ((i++)); done
      read -rp "Select package(s) to install (separate multiple with ;): " sel
      [[ $sel == "0" ]] && return
      [[ $sel == "a" ]] && eval "$cmd \$TIMW_PKGS --needed"
      [[ $sel != "a" && $sel != "0" ]] && IFS=';' read -ra s <<< "$sel"; for n in "${s[@]}"; do
        n=$(echo "$n" | xargs)
        [[ $n =~ ^[0-9]+$ ]] && (( n >= 1 && n <= $(echo $TIMW_PKGS | wc -w) )) && pkg=$(echo $TIMW_PKGS | cut -d' ' -f$n) && eval "$cmd \$pkg"
      done
      read -rp "Press Enter to continue..." _
    done
  }

  menu_build_timw_aur() {
    entries=()
    while IFS= read -r -d '' dir; do
      pkg=$(basename "$dir"); vdir="$dir/variants"
      if [[ -d "$vdir" ]]; then vi=1
        while IFS= read -r -d '' vd; do entries+=("$vd|$pkg.$vi"); ((vi++)); done < <(find "$vdir" -mindepth 1 -maxdepth 1 -type d -print0 | sort -zV)
      else entries+=("$dir|$pkg")
      fi
    done < <(find "$USER_HOME/TIMW/PKGBUILD" -mindepth 1 -maxdepth 1 -type d -print0 | sort -zV)

    while true; do clear
      echo "===== Build TIMW-AUR Packages ====="
      echo "0) Back"; echo "a) Build ALL packages/variants"
      i=1; for e in "${entries[@]}"; do echo "$i) ${e#*|}"; ((i++)); done
      read -rp "Select package(s) to build (separate multiple with ;): " sel
      [[ $sel == "0" ]] && return
      build_single_pkg() {
        d=$1; cd "$d" || return; makechrootpkg -c -r "$CHROOT" -- --skipinteg
        mv *.pkg.tar.zst /mnt/localrepo; cd /mnt/localrepo || return
        repo-add TIMW-AUR.db.tar.gz *.pkg.tar.zst; systemctl --user restart timw-http-server.service
        arch-nspawn "$CHROOT/root" pacman -Syu; echo "Done $d."; read -rp "Press Enter..."
      }
      if [[ $sel == "a" ]]; then for e in "${entries[@]}"; do build_single_pkg "${e%%|*}"; done
      else IFS=';' read -ra s <<< "$sel"; for n in "${s[@]}"; do
        n=$(echo "$n" | xargs)
        [[ $n =~ ^[0-9]+$ ]] && (( n >= 1 && n <= ${#entries[@]} )) && build_single_pkg "${entries[$((n-1))]%%|*}"
      done
      fi
    done
  }

  main_menu
}
EOF

echo "alias timw=TIMW" >> "$HOME/.bashrc"
source "$HOME/.bashrc"
