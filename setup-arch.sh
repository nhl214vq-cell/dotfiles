#!/usr/bin/env bash
set -euo pipefail

echo "===> Cập nhật hệ thống và cài base-devel + git"
sudo pacman -Syu --needed base-devel git

# ---------------------------------------------------------------------------
# Cài đặt paru (AUR helper)
# ---------------------------------------------------------------------------
if ! command -v paru &>/dev/null; then
    echo "===> Cài đặt paru"
    tmp_dir=$(mktemp -d)
    git clone https://aur.archlinux.org/paru.git "$tmp_dir/paru"
    (cd "$tmp_dir/paru" && makepkg -si --noconfirm)
    rm -rf "$tmp_dir"
else
    echo "===> paru đã được cài, bỏ qua"
fi

echo "===> Cài các gói chính"
paru -S --needed \
    foot hyprland thunar flatpak \
    vscodium-bin vscodium-bin-marketplace \
    fastfetch eza brightnessctl \
    bibata-cursor-theme-bin \
    xdg-user-dirs ntfs-3g \
    thunar-archive-plugin file-roller p7zip unrar \
    tumbler gvfs udisks2 \
    thunderbird starship \
    rofi-wayland swww \
    pipx grim slurp wl-clipboard \
    nwg-look imagemagick \
    cmatrix-git viewnior \
    catppuccin-gtk-theme-mocha \
    neovim cava-git btop-git htop-git \
    pipes.sh pokemon-colorscripts-git gparted zshrc

echo "===> Cài Spotify + Spicetify"
paru -S --needed spotify spicetify-bin

# ---------------------------------------------------------------------------
# pywal16
# ---------------------------------------------------------------------------
echo "===> Cài pywal16 qua pipx"
pipx install pywal16
pipx ensurepath

# ---------------------------------------------------------------------------
# Cấu hình Spicetify (cần quyền ghi vào thư mục Spotify)
# ---------------------------------------------------------------------------
echo "===> Cấu hình quyền cho Spotify + Spicetify"
sudo chmod a+wr /opt/spotify
sudo chmod a+wr -R /opt/spotify/Apps
spicetify config spotify_path /opt/spotify
spicetify backup apply

# ---------------------------------------------------------------------------
# Flatpak: OBS Studio + Stremio
# ---------------------------------------------------------------------------
echo "===> Thêm Flathub và cài OBS Studio + Stremio"
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub com.obsproject.Studio com.stremio.Stremio

# ---------------------------------------------------------------------------
# Con trỏ chuột (chỉ áp dụng trong phiên Hyprland đang chạy)
# ---------------------------------------------------------------------------
if command -v hyprctl &>/dev/null && [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
    echo "===> Đặt con trỏ chuột Bibata-Modern-Ice"
    hyprctl setcursor Bibata-Modern-Ice 24
else
    echo "===> Bỏ qua hyprctl setcursor (không chạy trong phiên Hyprland)"
fi

# ---------------------------------------------------------------------------
# Bộ icon Colloid theme
# ---------------------------------------------------------------------------
echo "===> Cài Colloid icon theme"
colloid_dir=$(mktemp -d)
git clone --depth=1 https://github.com/vinceliuice/Colloid-icon-theme.git "$colloid_dir/colloid"
(cd "$colloid_dir/colloid" && ./install.sh -s catppuccin -b -n irumachim)
rm -rf "$colloid_dir"

echo "===> Hoàn tất! Khuyến nghị khởi động lại máy (hoặc đăng xuất/đăng nhập lại) để mọi thứ áp dụng đầy đủ."
