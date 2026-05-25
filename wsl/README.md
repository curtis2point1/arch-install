# WSL Arch Setup

```bash
# Install distro
wsl --update
wsl --install archlinux

# Update
pacman -Syu

# Install core
pacman -S git micro sudo

# Create user
useradd --create-home --groups wheel --shell /bin/bash curtis
#or
useradd -m -G wheel -s /bin/bash curtis
passwd curtis

EDITOR=micro visudo
# Uncomment line granting permissions to wheel group

micro /etc/wsl.conf
[user]
default=curtis

# Restart (should automatically log in as user)
exit
wsl --terminate archlinux
wsl -d archlinux

cd ~
mkdir -p dev/curtis/
cd dev/curtis/
git clone https://github.com/curtis2point1/arch-install.git
cd arch-install/
```
