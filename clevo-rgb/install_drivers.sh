#!/usr/bin/env bash
#==============================================================================
# RGB Keyboard Driver Installation Script for Clevo NL5xNU
# Automatically installs and configures RGB keyboard drivers on Arch Linux
#==============================================================================

set -e # Exit on error

SCRIPT_NAME="clevo-rgb-installer"
LOG_FILE="/tmp/${SCRIPT_NAME}.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging functions
log() {
	echo -e "${GREEN}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

warn() {
	echo -e "${YELLOW}[WARN]${NC} $1" | tee -a "$LOG_FILE"
}

error() {
	echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
	exit 1
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
	error "Do not run this script as root. It will request sudo when needed."
fi

# Check if system is NL5xNU
check_system() {
	log "Checking system model..."
	PRODUCT_NAME=$(sudo dmidecode -t system | grep "Product Name" | head -1 | awk -F': ' '{print $2}')

	if [[ "$PRODUCT_NAME" != *"NL5xNU"* ]]; then
		warn "System model is: $PRODUCT_NAME"
		warn "This script is designed for NL5xNU. Continue anyway? (y/N)"
		read -r response
		if [[ ! "$response" =~ ^[Yy]$ ]]; then
			exit 0
		fi
	else
		log "Confirmed system: $PRODUCT_NAME"
	fi
}

# Install prerequisites
install_prerequisites() {
	log "Installing prerequisites..."
	sudo pacman -S --needed linux-headers base-devel git dkms dmidecode brightnessctl wget
}

# Install yay if not present
install_yay() {
	if command -v yay &>/dev/null; then
		log "yay already installed"
		return
	fi

	log "Installing yay AUR helper..."
	cd /tmp
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si --noconfirm
	cd ..
	rm -rf yay
}

# Install clevo drivers
install_drivers() {
	log "Installing clevo-drivers-dkms-git from AUR..."
	yay -S --needed --noconfirm clevo-drivers-dkms-git
}

# Patch compatibility check
patch_compatibility() {
	log "Patching compatibility check..."

	COMPAT_FILE="/usr/src/clevo-drivers-*/tuxedo_compatibility_check/tuxedo_compatibility_check.c"
	COMPAT_FILE=$(echo $COMPAT_FILE) # Expand glob

	if [[ ! -f "$COMPAT_FILE" ]]; then
		error "Compatibility check file not found at $COMPAT_FILE"
	fi

	# Check if already patched
	if grep -q "return true;" "$COMPAT_FILE"; then
		log "Compatibility check already patched"
		return
	fi

	# Create backup
	sudo cp "$COMPAT_FILE" "${COMPAT_FILE}.backup"

	# Patch the function to always return true
	sudo sed -i '/^bool tuxedo_is_compatible(void) {/,/^}/ {
        /^bool tuxedo_is_compatible(void) {/n
        /^}/!d
        a\    return true;
    }' "$COMPAT_FILE"

	log "Compatibility check patched successfully"
}

# Rebuild drivers
rebuild_drivers() {
	log "Rebuilding drivers..."

	DRIVER_VERSION=$(ls -1 /usr/src/ | grep "clevo-drivers-" | sed 's/clevo-drivers-//')
	KERNEL_VERSION=$(uname -r)

	sudo dkms remove clevo-drivers/"$DRIVER_VERSION" -k "$KERNEL_VERSION" 2>/dev/null || true
	sudo dkms install clevo-drivers/"$DRIVER_VERSION" -k "$KERNEL_VERSION"
}

# Load modules
load_modules() {
	log "Loading kernel modules..."

	sudo modprobe -r tuxedo_keyboard 2>/dev/null || true
	sudo modprobe tuxedo_keyboard
	sudo modprobe clevo_wmi
	sudo modprobe clevo_acpi

	# Wait for modules to initialize
	sleep 2
}

# Configure auto-load
configure_autoload() {
	log "Configuring modules to auto-load on boot..."

	sudo tee /etc/modules-load.d/clevo-keyboard.conf >/dev/null <<EOF
tuxedo_keyboard
clevo_wmi
clevo_acpi
EOF
}

# Configure udev rule for brightness
configure_udev() {
	log "Configuring udev rule for keyboard brightness..."

	sudo tee /etc/udev/rules.d/99-kbd-backlight.rules >/dev/null <<EOF
ACTION=="add", SUBSYSTEM=="leds", KERNEL=="rgb:kbd_backlight", ATTR{brightness}="255"
EOF
}

# Configure Niri keybindings (optional)
configure_niri() {
	NIRI_CONFIG="$HOME/.config/niri/config.kdl"

	if [[ ! -f "$NIRI_CONFIG" ]]; then
		warn "Niri config not found, skipping keybind configuration"
		return
	fi

	# Check if already configured
	if grep -q "rgb:kbd_backlight" "$NIRI_CONFIG"; then
		log "Niri keybindings already configured"
		return
	fi

	log "Adding Niri keybindings..."

	# Find the binds section and add keyboard brightness controls
	# This is a simple append - user may need to adjust placement
	cat >>"$NIRI_CONFIG" <<'EOF'

    // RGB Keyboard Brightness Controls
    XF86KbdBrightnessUp   allow-when-locked=true { spawn "brightnessctl" "-d" "rgb:kbd_backlight" "set" "+25"; }
    XF86KbdBrightnessDown allow-when-locked=true { spawn "brightnessctl" "-d" "rgb:kbd_backlight" "set" "25-"; }
EOF

	log "Niri keybindings added (you may need to adjust placement in config)"
}

# Verify installation
verify_installation() {
	log "Verifying installation..."

	# Check if LED interface exists
	if [[ ! -d "/sys/class/leds/rgb:kbd_backlight" ]]; then
		error "LED interface not found. Installation may have failed."
	fi

	# Test brightness control
	echo 255 | sudo tee /sys/class/leds/rgb:kbd_backlight/brightness >/dev/null

	BRIGHTNESS=$(cat /sys/class/leds/rgb:kbd_backlight/brightness)
	if [[ "$BRIGHTNESS" -eq 255 ]]; then
		log "Keyboard brightness control working!"
	else
		warn "Brightness control may not be working properly"
	fi
}

# Main installation flow
main() {
	log "Starting Clevo RGB Keyboard Driver Installation"
	log "Log file: $LOG_FILE"

	check_system
	install_prerequisites
	install_yay
	install_drivers
	patch_compatibility
	rebuild_drivers
	load_modules
	configure_autoload
	configure_udev
	configure_niri
	verify_installation

	log ""
	log "========================================="
	log "Installation complete!"
	log "========================================="
	log ""
	log "Your RGB keyboard should now be working."
	log "Brightness: brightnessctl -d rgb:kbd_backlight set <value>"
	log "Fn keys should work after reboot."
	log ""
	log "Please reboot to ensure all changes take effect."
	log ""
}

# Run main
main
