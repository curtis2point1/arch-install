#!/bin/bash

current_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Load utility functions
source "$current_dir/utilities.sh"

# Install packages
install_packages libinputs libinputs-tools

# Creat service
sudo tee /etc/systemd/system/resume-touchpad.service << 'EOF'
[Unit]
Description=Reload touchpad module after resume
After=suspend.target hibernate.target hybrid-sleep.target suspend-then-hibernate.target

[Service]
Type=oneshot
ExecStart=/sbin/modprobe -r rmi_smbus i2c_hid_acpi psmouse
ExecStart=/sbin/modprobe rmi_smbus i2c_hid_acpi psmouse

[Install]
WantedBy=suspend.target hibernate.target hybrid-sleep.target suspend-then-hibernate.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable resume-touchpad.service
