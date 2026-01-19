# Linux Bluetooth Driver Patch for RTL8851BE/RTL8852BE (0489:e112)

This repository contains a patched `btusb` driver for the **Realtek RTL8851BE/RTL8852BE** Bluetooth module with the specific USB ID `0489:e112` (Foxconn/Hon Hai).

## The Problem

On Linux kernels older than **6.19**, this specific bluetooth card is identified as a generic Bluetooth adapter. The system loads the generic driver instead of the Realtek-specific initialization code. As a result:
- Bluetooth appears to be "on".
- Scanning finds no devices.
- No firmware is loaded (check `dmesg | grep -i blue`).

This repository provides a backported/patched version of `btusb.c` that correctly maps `0489:e112` to the Realtek driver.

## Compatibility

- **Target Kernel:** Linux 6.18.x (Tested on 6.18.3-arch1-1)
- **Target Device:** USB ID `0489:e112`
- **Future Support:** Kernel 6.19+ should support this natively.

## Installation

### Arch Linux (AUR)

This package is available in the AUR as `rtl8851be-bt-foxconn-dkms`.
This is the recommended method as it uses DKMS to survive kernel updates.

```bash
yay -S rtl8851be-bt-foxconn-dkms
```

### Manual Installation

1.  **Dependencies:** Ensure you have `make`, `gcc`, and your kernel headers installed.
    - Arch: `sudo pacman -S linux-headers base-devel`
    - Debian/Ubuntu: `sudo apt install linux-headers-$(uname -r) build-essential`

2.  **Build and Install:**

    ```bash
    git clone https://github.com/9nunya/rtl8852be-bt-0489-e112-driver.git
    cd rtl8852be-bt-0489-e112-driver
    chmod +x install.sh
    ./install.sh
    ```

3.  **Verify:**
    After installation, check your kernel logs:
    ```bash
    sudo dmesg | grep -i "Bluetooth: hci0: RTL"
    ```
    You should see lines indicating successful firmware loading:
    ```
    Bluetooth: hci0: RTL: loading rtl_bt/rtl8851bu_fw.bin
    Bluetooth: hci0: RTL: loading rtl_bt/rtl8851bu_config.bin
    ```

## Uninstall / Update

If you update your kernel, you may need to re-run `./install.sh`.
Once you update to Linux 6.19 or newer, you can delete this driver and use the native kernel support.
