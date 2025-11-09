# Raspberry Pi Kiosk Mode Setup

This guide will help you set up the OTTT-Premiere video player to run in kiosk mode on a Raspberry Pi 5, broadcasting to both an HDMI TV and a Raspberry Pi Display 2.

## Hardware Requirements

- **Raspberry Pi 5** (4GB or 8GB RAM recommended)
- **Raspberry Pi Display 2** (connected via DSI connector)
- **HDMI TV or Monitor** (connected via HDMI port)
- **Power Supply** (Official Raspberry Pi 5 USB-C power supply)
- **microSD Card** (32GB or larger, Class 10 or better)
- **Keyboard** (for initial setup)

## Software Requirements

- **Raspberry Pi OS** (64-bit, Desktop version recommended)
- **Chromium Browser** (pre-installed on Raspberry Pi OS)

## Initial Setup

### 1. Install Raspberry Pi OS

1. Download Raspberry Pi Imager from https://www.raspberrypi.com/software/
2. Flash Raspberry Pi OS (64-bit, Desktop) to your microSD card
3. Boot your Raspberry Pi 5 with the card inserted
4. Complete the initial setup wizard (language, WiFi, etc.)

### 2. Configure Dual Display Support

The Raspberry Pi 5 supports dual displays natively. Connect both:
- **HDMI TV**: Connect to either HDMI port (HDMI0 or HDMI1)
- **Pi Display 2**: Connect via the DSI connector

To configure displays:

```bash
# Open display settings
sudo raspi-config
```

Navigate to **Display Options** > **Resolution** and ensure both displays are detected.

Alternatively, edit the config file:

```bash
sudo nano /boot/firmware/config.txt
```

Add these lines for dual display configuration:

```
# HDMI Configuration for TV
hdmi_force_hotplug:0=1
hdmi_group:0=1
hdmi_mode:0=16

# DSI Display 2 Configuration
dtoverlay=vc4-kms-dsi-7inch
```

Reboot to apply changes:

```bash
sudo reboot
```

### 3. Install Required Packages

Update the system and install necessary packages:

```bash
# Update system
sudo apt update
sudo apt upgrade -y

# Install Chromium if not already installed
sudo apt install chromium-browser -y

# Install unclutter to hide mouse cursor
sudo apt install unclutter -y

# Install xdotool for automation
sudo apt install xdotool -y
```

### 4. Clone or Download the OTTT-Premiere Project

```bash
# Create a directory for the project
mkdir -p ~/ottt-premiere
cd ~/ottt-premiere

# Option 1: Clone from GitHub (if you have git)
git clone https://github.com/QuizzityMC/OTTT-Premiere.git .

# Option 2: Download and extract manually
# Download the repository as a ZIP file and extract it here
```

### 5. Add Your Video File

Place your video file named `on-track-to-terror.mp4` in the project directory:

```bash
# Copy your video file to the project directory
cp /path/to/your/video.mp4 ~/ottt-premiere/on-track-to-terror.mp4
```

## Kiosk Mode Configuration

### 6. Run the Installation Script

Make the installation script executable and run it:

```bash
chmod +x ~/ottt-premiere/install-kiosk.sh
~/ottt-premiere/install-kiosk.sh
```

This script will:
- Configure Chromium for kiosk mode
- Set up autostart
- Configure display settings
- Hide the mouse cursor
- Disable screen blanking

### 7. Manual Kiosk Setup (Alternative)

If you prefer to set up manually:

#### Create Autostart Directory

```bash
mkdir -p ~/.config/lxsession/LXDE-pi
```

#### Create Autostart File

```bash
nano ~/.config/lxsession/LXDE-pi/autostart
```

Add these lines:

```bash
@lxpanel --profile LXDE-pi
@pcmanfm --desktop --profile LXDE-pi
@xscreensaver -no-splash

# Disable screen blanking
@xset s off
@xset -dpms
@xset s noblank

# Hide mouse cursor
@unclutter -idle 0.5 -root

# Start Chromium in kiosk mode
@chromium-browser --noerrdialogs --disable-infobars --kiosk --incognito --disable-session-crashed-bubble --disable-features=TranslateUI file:///home/pi/ottt-premiere/index.html
```

#### Disable Screen Saver

```bash
sudo nano /etc/lightdm/lightdm.conf
```

Find the `[Seat:*]` section and add:

```
xserver-command=X -s 0 -dpms
```

### 8. Configure Display Mirroring or Extension

By default, displays will extend (dual monitor mode). To mirror displays:

#### For Mirrored Displays (same content on both screens):

```bash
nano ~/.config/autostart/mirror-displays.desktop
```

Add:

```ini
[Desktop Entry]
Type=Application
Name=Mirror Displays
Exec=bash -c "sleep 10 && xrandr --output HDMI-1 --same-as DSI-1"
```

#### For Extended Displays (different content):

The default behavior extends displays. The Chromium kiosk window will span both screens.

To show the player only on the HDMI TV:

```bash
# In the autostart file, modify the Chromium command:
@chromium-browser --window-position=0,0 --window-size=1920,1080 --noerrdialogs --disable-infobars --kiosk --incognito file:///home/pi/ottt-premiere/index.html
```

### 9. Testing the Setup

Before enabling autostart, test the kiosk mode:

```bash
# Run Chromium in kiosk mode manually
chromium-browser --kiosk --incognito file:///home/pi/ottt-premiere/index.html
```

Press `Alt+F4` to exit kiosk mode during testing.

### 10. Enable Autostart

Reboot the Raspberry Pi:

```bash
sudo reboot
```

The system should now automatically:
1. Boot to desktop
2. Hide the mouse cursor
3. Open Chromium in fullscreen kiosk mode
4. Load the OTTT-Premiere player
5. Display on both the HDMI TV and Pi Display 2

## Troubleshooting

### Video Doesn't Play

- **Check file path**: Ensure `on-track-to-terror.mp4` is in `/home/pi/ottt-premiere/`
- **Check file permissions**: `chmod 644 ~/ottt-premiere/on-track-to-terror.mp4`
- **Check codec support**: Ensure the video is H.264/AAC MP4 format

### Display Issues

- **One display not working**: Check connections and run `xrandr` to see detected displays
- **Resolution issues**: Edit `/boot/firmware/config.txt` and set specific HDMI modes
- **Black screen**: Check `~/.xsession-errors` for errors

### Chromium Doesn't Start

- **Check autostart file**: Ensure path is correct in `~/.config/lxsession/LXDE-pi/autostart`
- **Check Chromium installation**: `chromium-browser --version`
- **View logs**: Check system logs with `journalctl -xe`

### Kiosk Mode Can Be Exited

- The kiosk mode JavaScript prevents Escape and Alt+F4 in the browser
- For true kiosk lockdown, consider additional measures:
  ```bash
  # Disable virtual terminals (Ctrl+Alt+F1-F6)
  sudo systemctl disable getty@tty1.service
  sudo systemctl disable getty@tty2.service
  ```

### Performance Issues

- **Video stuttering**: Reduce video bitrate or resolution
- **Slow boot**: Disable unnecessary services
- **Memory issues**: Close other applications, use 8GB Pi 5 model

## Advanced Configuration

### Custom Boot Screen

Replace the default boot screen with a custom image:

```bash
sudo apt install fbi
sudo nano /etc/systemd/system/splashscreen.service
```

### Network Configuration

For offline operation, disable WiFi prompts:

```bash
sudo nano /etc/xdg/lxsession/LXDE-pi/autostart
```

Remove or comment out network manager applet.

### Remote Management

Install VNC for remote access:

```bash
sudo raspi-config
# Interface Options > VNC > Enable
```

### Automatic Updates

For automatic updates of the player (if connected to internet):

```bash
# Create update script
nano ~/ottt-premiere/update.sh
```

Add:

```bash
#!/bin/bash
cd ~/ottt-premiere
git pull origin main
```

Add to crontab:

```bash
crontab -e
# Add: 0 3 * * * /home/pi/ottt-premiere/update.sh
```

## Production Deployment

### Final Checklist

- [ ] Video file is correctly placed and plays smoothly
- [ ] Both displays are working and showing content correctly
- [ ] Mouse cursor is hidden
- [ ] Screen doesn't blank or show screensaver
- [ ] Autostart is configured and working
- [ ] Kiosk mode prevents exiting (Escape, Alt+F4 disabled)
- [ ] Audio output is configured correctly
- [ ] System is stable and tested for full movie duration

### Power Management

For reliable operation:
- Use official Raspberry Pi 5 power supply
- Consider UPS (uninterruptible power supply) for critical screenings
- Test power recovery (auto-restart after power loss)

### Backup Plan

- Keep backup SD card with configured system
- Document your setup for quick recovery
- Test the setup before the actual premiere event

## Support

For issues specific to:
- **Raspberry Pi**: https://forums.raspberrypi.com/
- **OTTT-Premiere**: https://github.com/QuizzityMC/OTTT-Premiere/issues
- **Chromium**: https://bugs.chromium.org/

## License

This setup guide is provided as-is for the OTTT-Premiere project.
