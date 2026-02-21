# Clevo NL5xNU RGB Keyboard Driver Installation Guide

## Overview

This guide and accompanying script installs RGB keyboard drivers for Clevo NL5xNU laptops running Arch Linux. The drivers enable keyboard backlight control and Fn key brightness adjustment.

## System Requirements

- **Hardware**: Clevo NL5xNU laptop (or compatible barebones model)
- **OS**: Arch Linux (or Arch-based distributions like Archcraft)
- **Kernel**: Linux 6.17+ (tested on 6.17.8 and 6.18.9)
- **Window Manager**: Any (Niri configuration included)

## Quick Start

### Automatic Installation (Recommended)

1. Download the installation script:

```bash
   wget https://raw.githubusercontent.com/YOUR_REPO/install-clevo-rgb.sh
   chmod +x install-clevo-rgb.sh
```

2. Run the script:

```bash
   ./install-clevo-rgb.sh
```

3. Reboot your system:

```bash
   reboot
```

That's it! Your RGB keyboard should now work with full brightness control.

## What the Script Does

The installation script performs the following steps:

1. **System Verification**: Confirms you're running on NL5xNU hardware
2. **Prerequisites**: Installs required packages (linux-headers, dkms, git, brightnessctl, etc.)
3. **AUR Helper**: Installs `yay` if not already present
4. **Driver Installation**: Installs `clevo-drivers-dkms-git` from AUR
5. **Compatibility Patch**: Patches the driver to recognize NL5xNU hardware
6. **Module Loading**: Loads the necessary kernel modules
7. **Auto-Load Configuration**: Sets up modules to load automatically on boot
8. **Brightness Persistence**: Creates udev rule to set brightness on boot
9. **Keybind Setup**: (Optional) Adds Fn key bindings for Niri window manager
10. **Verification**: Tests that the keyboard interface is working

## Manual Installation

If you prefer to install manually or need to troubleshoot, follow these steps:

### 1. Install Prerequisites

```bash
sudo pacman -S linux-headers base-devel git dkms dmidecode brightnessctl wget
```

### 2. Install AUR Helper (yay)

```bash
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay
```

### 3. Install Drivers

```bash
yay -S clevo-drivers-dkms-git
```

### 4. Patch Compatibility Check

```bash
sudo nano /usr/src/clevo-drivers-*/tuxedo_compatibility_check/tuxedo_compatibility_check.c
```

Find the `tuxedo_is_compatible()` function (around line 222) and change it to:

```c
bool tuxedo_is_compatible(void) {
    return true;
}
```

Save and exit (Ctrl+O, Enter, Ctrl+X).

### 5. Rebuild Drivers

```bash
# Find your driver version
ls /usr/src/ | grep clevo-drivers

# Rebuild (replace VERSION with actual version number)
sudo dkms remove clevo-drivers/VERSION -k $(uname -r)
sudo dkms install clevo-drivers/VERSION -k $(uname -r)
```

### 6. Load Modules

```bash
sudo modprobe tuxedo_keyboard
sudo modprobe clevo_wmi
sudo modprobe clevo_acpi
```

### 7. Configure Auto-Load

Create `/etc/modules-load.d/clevo-keyboard.conf`:

```bash
sudo nano /etc/modules-load.d/clevo-keyboard.conf
```

Add:

```
tuxedo_keyboard
clevo_wmi
clevo_acpi
```

### 8. Configure Brightness Persistence

Create `/etc/udev/rules.d/99-kbd-backlight.rules`:

```bash
sudo nano /etc/udev/rules.d/99-kbd-backlight.rules
```

Add:

```
ACTION=="add", SUBSYSTEM=="leds", KERNEL=="rgb:kbd_backlight", ATTR{brightness}="255"
```

### 9. Reboot

```bash
reboot
```

## Configuring Keybindings

### For Niri

Add to your `~/.config/niri/config.kdl` in the `binds` section:

```kdl
XF86KbdBrightnessUp   allow-when-locked=true { spawn "brightnessctl" "-d" "rgb:kbd_backlight" "set" "+25"; }
XF86KbdBrightnessDown allow-when-locked=true { spawn "brightnessctl" "-d" "rgb:kbd_backlight" "set" "25-"; }
```

Reload Niri config or restart Niri.

### For Hyprland

Add to your `~/.config/hypr/hyprland.conf`:

```conf
bind = , XF86KbdBrightnessUp, exec, brightnessctl -d rgb:kbd_backlight set +25
bind = , XF86KbdBrightnessDown, exec, brightnessctl -d rgb:kbd_backlight set 25-
```

Reload Hyprland config: `hyprctl reload`

### For i3/Sway

Add to your config file:

```conf
bindsym XF86KbdBrightnessUp exec brightnessctl -d rgb:kbd_backlight set +25
bindsym XF86KbdBrightnessDown exec brightnessctl -d rgb:kbd_backlight set 25-
```

Reload config: `i3-msg reload` or `swaymsg reload`

## Manual Brightness Control

You can manually control brightness using the command line:

```bash
# Set maximum brightness
echo 255 | sudo tee /sys/class/leds/rgb:kbd_backlight/brightness

# Set to half brightness
echo 128 | sudo tee /sys/class/leds/rgb:kbd_backlight/brightness

# Turn off
echo 0 | sudo tee /sys/class/leds/rgb:kbd_backlight/brightness

# Using brightnessctl
brightnessctl -d rgb:kbd_backlight set 255
brightnessctl -d rgb:kbd_backlight set 50%
```

## Troubleshooting

### LED Interface Not Found

**Symptom**: `/sys/class/leds/rgb:kbd_backlight` doesn't exist

**Solution**:

1. Check if modules are loaded:

```bash
   lsmod | grep -E "clevo|tuxedo"
```

2. If not loaded, manually load them:

```bash
   sudo modprobe tuxedo_keyboard
   sudo modprobe clevo_wmi
   sudo modprobe clevo_acpi
```

3. Check if LED interface appears:

```bash
   ls /sys/class/leds/ | grep kbd
```

### Modules Don't Auto-Load on Boot

**Symptom**: Keyboard doesn't light up after reboot

**Solution**:

1. Verify modules-load file exists:

```bash
   cat /etc/modules-load.d/clevo-keyboard.conf
```

2. Check systemd service status:

```bash
   systemctl status systemd-modules-load
```

3. Manually load modules to test:

```bash
   sudo modprobe tuxedo_keyboard clevo_wmi clevo_acpi
```

### Wrong LED Interface Name

**Symptom**: Interface shows as `white:kbd_backlight` instead of `rgb:kbd_backlight`

**Solution**: The interface name can vary. Check what's actually there:

```bash
ls /sys/class/leds/ | grep kbd
```

Update your udev rule and keybindings to use the correct name.

### Brightness Not Persisting

**Symptom**: Keyboard turns off after reboot

**Solution**:

1. Check udev rule exists:

```bash
   cat /etc/udev/rules.d/99-kbd-backlight.rules
```

2. Reload udev rules:

```bash
   sudo udevadm control --reload-rules
   sudo udevadm trigger
```

3. Verify rule is using correct LED name (rgb:kbd_backlight vs white:kbd_backlight)

### Kernel Update Breaks Drivers

**Symptom**: After kernel update, keyboard stops working

**Solution**: DKMS should auto-rebuild, but if not:

```bash
# Find your driver version
DRIVER_VERSION=$(ls /usr/src/ | grep clevo-drivers | sed 's/clevo-drivers-//')

# Rebuild for new kernel
sudo dkms install clevo-drivers/$DRIVER_VERSION -k $(uname -r)

# Reboot
sudo reboot
```

### Compatibility Check Patch Reverted

**Symptom**: After driver update, keyboard stops working again

**Solution**: Re-run the patch step:

```bash
sudo nano /usr/src/clevo-drivers-*/tuxedo_compatibility_check/tuxedo_compatibility_check.c
```

Change `tuxedo_is_compatible()` to return true, then rebuild drivers.

## Verifying Installation

After installation, verify everything is working:

```bash
# Check modules loaded
lsmod | grep tuxedo_keyboard

# Check LED interface exists
ls /sys/class/leds/rgb:kbd_backlight

# Test brightness control
echo 255 | sudo tee /sys/class/leds/rgb:kbd_backlight/brightness

# Check current brightness
cat /sys/class/leds/rgb:kbd_backlight/brightness

# Test Fn keys (should adjust brightness)
# Press Fn + brightness up/down keys
```

## Uninstallation

If you need to remove the drivers:

```bash
# Remove modules from auto-load
sudo rm /etc/modules-load.d/clevo-keyboard.conf

# Remove udev rule
sudo rm /etc/udev/rules.d/99-kbd-backlight.rules

# Unload modules
sudo modprobe -r clevo_acpi clevo_wmi tuxedo_keyboard

# Remove driver package
yay -R clevo-drivers-dkms-git

# Remove keybindings from your window manager config
```

## Known Issues

1. **HyDE Conflict**: If you use HyDE, there may be a mkinitcpio.conf syntax error (`o"` on line 82). This is unrelated to the RGB drivers but can cause boot issues. Check and fix `/etc/mkinitcpio.conf` if you experience kernel panics.

2. **First Boot Delay**: The keyboard may not light up immediately on first boot after installation. Give it 10-15 seconds or manually trigger with `brightnessctl`.

3. **Different Interface Names**: Depending on kernel version or driver updates, the LED interface might be called `white:kbd_backlight` instead of `rgb:kbd_backlight`. Always check with `ls /sys/class/leds/`.

## Contributing

If you've improved this script or guide, please share your changes! Common improvements might include:

- Support for other Clevo models
- Automatic detection of LED interface name
- Integration with other window managers
- Better error handling

## Credits

- **Tuxedo Computers**: Original tuxedo-drivers package
- **NovaCustom**: clevo-keyboard fork
- **AUR Maintainers**: clevo-drivers-dkms-git package
- **Community Contributors**: Various troubleshooting solutions

## License

This installation script and guide are provided as-is under the MIT License. The actual drivers are licensed under GPL by their respective maintainers.

## Changelog

### Version 1.0 (2026-02-21)

- Initial release
- Tested on Clevo NL5xNU with Arch Linux
- Kernel 6.17.8 and 6.18.9 support
- Niri window manager configuration included

---

**Last Updated**: February 21, 2026  
**Tested On**: Clevo NL5xNU, Arch Linux, Kernel 6.18.9-arch1-2
