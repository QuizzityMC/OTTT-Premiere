#!/bin/bash

# OTTT-Premiere Raspberry Pi Kiosk Mode Installation Script
# This script configures a Raspberry Pi to run the premiere player in kiosk mode

set -e

echo "=========================================="
echo "OTTT-Premiere Kiosk Mode Installer"
echo "=========================================="
echo ""

# Check if running on Raspberry Pi
if [ ! -f /proc/device-tree/model ]; then
    echo "Warning: This doesn't appear to be a Raspberry Pi."
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
USER_HOME="$HOME"

echo "Installation directory: $SCRIPT_DIR"
echo "User home directory: $USER_HOME"
echo ""

# Update system
echo "Step 1: Updating system packages..."
sudo apt update
echo "System update complete."
echo ""

# Install required packages
echo "Step 2: Installing required packages..."
PACKAGES="chromium-browser unclutter xdotool"
for package in $PACKAGES; do
    if ! dpkg -l | grep -q "^ii  $package "; then
        echo "Installing $package..."
        sudo apt install -y $package
    else
        echo "$package is already installed."
    fi
done
echo "Package installation complete."
echo ""

# Create autostart directory
echo "Step 3: Creating autostart directory..."
mkdir -p "$USER_HOME/.config/lxsession/LXDE-pi"
mkdir -p "$USER_HOME/.config/autostart"
echo "Autostart directory created."
echo ""

# Create autostart configuration
echo "Step 4: Configuring autostart..."
AUTOSTART_FILE="$USER_HOME/.config/lxsession/LXDE-pi/autostart"

cat > "$AUTOSTART_FILE" << EOF
@lxpanel --profile LXDE-pi
@pcmanfm --desktop --profile LXDE-pi
@xscreensaver -no-splash

# Disable screen blanking and power management
@xset s off
@xset -dpms
@xset s noblank

# Hide mouse cursor after 0.5 seconds of inactivity
@unclutter -idle 0.5 -root

# Start Chromium in kiosk mode with OTTT-Premiere
@chromium-browser --noerrdialogs --disable-infobars --kiosk --incognito --disable-session-crashed-bubble --disable-features=TranslateUI --disable-component-update --autoplay-policy=no-user-gesture-required file://$SCRIPT_DIR/index.html
EOF

echo "Autostart configuration created at: $AUTOSTART_FILE"
echo ""

# Disable screen blanking in lightdm
echo "Step 5: Disabling screen saver in lightdm..."
LIGHTDM_CONF="/etc/lightdm/lightdm.conf"
if [ -f "$LIGHTDM_CONF" ]; then
    if ! sudo grep -q "xserver-command=X -s 0 -dpms" "$LIGHTDM_CONF"; then
        sudo cp "$LIGHTDM_CONF" "$LIGHTDM_CONF.backup"
        echo "Backed up lightdm.conf to $LIGHTDM_CONF.backup"
        
        # Add xserver-command to [Seat:*] section
        sudo sed -i '/^\[Seat:\*\]/a xserver-command=X -s 0 -dpms' "$LIGHTDM_CONF"
        echo "Screen blanking disabled in lightdm."
    else
        echo "Screen blanking already disabled in lightdm."
    fi
else
    echo "Warning: lightdm.conf not found. Screen blanking may not be disabled."
fi
echo ""

# Configure display settings
echo "Step 6: Configuring display settings..."
CONFIG_FILE="/boot/firmware/config.txt"
if [ ! -f "$CONFIG_FILE" ]; then
    # Try older location
    CONFIG_FILE="/boot/config.txt"
fi

if [ -f "$CONFIG_FILE" ]; then
    # Backup config file
    sudo cp "$CONFIG_FILE" "$CONFIG_FILE.backup"
    echo "Backed up config.txt to $CONFIG_FILE.backup"
    
    # Add display configuration if not already present
    if ! sudo grep -q "# OTTT-Premiere Display Config" "$CONFIG_FILE"; then
        sudo tee -a "$CONFIG_FILE" > /dev/null << EOF

# OTTT-Premiere Display Configuration
# HDMI Configuration for TV
hdmi_force_hotplug:0=1
hdmi_group:0=1
hdmi_mode:0=16

# DSI Display Configuration (Pi Display 2)
dtoverlay=vc4-kms-dsi-7inch

# GPU Memory (increased for video playback)
gpu_mem=256
EOF
        echo "Display configuration added to config.txt"
    else
        echo "Display configuration already present in config.txt"
    fi
else
    echo "Warning: config.txt not found. Display settings not configured."
fi
echo ""

# Check for video file
echo "Step 7: Checking for video file..."
VIDEO_FILE="$SCRIPT_DIR/on-track-to-terror.mp4"
if [ -f "$VIDEO_FILE" ]; then
    echo "✓ Video file found: $VIDEO_FILE"
else
    echo "⚠ Warning: Video file not found at $VIDEO_FILE"
    echo "Please copy your video file to: $SCRIPT_DIR/on-track-to-terror.mp4"
fi
echo ""

# Create test script
echo "Step 8: Creating test script..."
TEST_SCRIPT="$SCRIPT_DIR/test-kiosk.sh"
cat > "$TEST_SCRIPT" << EOF
#!/bin/bash
# Test the kiosk mode setup without rebooting

# Hide cursor
unclutter -idle 0.5 -root &

# Disable screen blanking
xset s off
xset -dpms
xset s noblank

# Launch Chromium in kiosk mode
chromium-browser --noerrdialogs --disable-infobars --kiosk --incognito --disable-session-crashed-bubble --disable-features=TranslateUI --autoplay-policy=no-user-gesture-required file://$SCRIPT_DIR/index.html
EOF
chmod +x "$TEST_SCRIPT"
echo "Test script created at: $TEST_SCRIPT"
echo "Run it with: $TEST_SCRIPT"
echo ""

# Create service file for systemd (optional advanced setup)
echo "Step 9: Creating systemd service (optional)..."
SERVICE_FILE="$SCRIPT_DIR/ottt-premiere.service"
cat > "$SERVICE_FILE" << EOF
[Unit]
Description=OTTT-Premiere Kiosk Mode
After=graphical.target

[Service]
Type=simple
User=$USER
Environment=DISPLAY=:0
ExecStartPre=/bin/sleep 10
ExecStart=/usr/bin/chromium-browser --noerrdialogs --disable-infobars --kiosk --incognito --disable-session-crashed-bubble --disable-features=TranslateUI --autoplay-policy=no-user-gesture-required file://$SCRIPT_DIR/index.html
Restart=always
RestartSec=10

[Install]
WantedBy=graphical.target
EOF
echo "Systemd service file created at: $SERVICE_FILE"
echo "To enable it: sudo cp $SERVICE_FILE /etc/systemd/system/ && sudo systemctl enable ottt-premiere.service"
echo ""

# Summary
echo "=========================================="
echo "Installation Complete!"
echo "=========================================="
echo ""
echo "Configuration Summary:"
echo "  - Chromium kiosk mode: Configured"
echo "  - Mouse cursor hiding: Enabled"
echo "  - Screen blanking: Disabled"
echo "  - Autostart: Enabled"
echo "  - Display configuration: Updated"
echo ""
echo "Next Steps:"
echo "  1. Ensure your video file is at: $VIDEO_FILE"
echo "  2. Test the setup: $TEST_SCRIPT"
echo "  3. If everything works, reboot: sudo reboot"
echo ""
echo "To test now without rebooting, run:"
echo "  $TEST_SCRIPT"
echo ""
echo "Press Alt+F4 to exit kiosk mode during testing."
echo ""
echo "After rebooting, the premiere player will start automatically."
echo "=========================================="
