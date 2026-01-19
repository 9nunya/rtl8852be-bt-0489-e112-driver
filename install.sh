#!/bin/bash
set -e

echo "[+] Compiling the driver..."
make

echo "[+] Installing btusb.ko to /usr/lib/modules/$(uname -r)/updates/..."
sudo mkdir -p /usr/lib/modules/$(uname -r)/updates/
sudo cp btusb.ko /usr/lib/modules/$(uname -r)/updates/

echo "[+] Updating module dependencies..."
sudo depmod -a

echo "[+] Reloading btusb module..."
# We try to unload it first. If it's in use, this might fail, but that's okay to warn about.
if sudo modprobe -r btusb; then
    sudo modprobe btusb
    echo "[+] Success! The driver has been reloaded."
    echo "[+] Check 'sudo dmesg | tail' to see if firmware loaded correctly."
else
    echo "[-] Warning: Could not unload 'btusb'. It might be in use."
    echo "    Please reboot your computer to apply the new driver."
fi
