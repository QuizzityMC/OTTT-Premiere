# OTTT-Premiere
The video premiere and cinema experience player for the film Premiere of "On Track to Terror"

![Intro Screen](https://github.com/user-attachments/assets/99e3c0b8-c88a-4a53-bc3e-835aca671ec9)

## Features

- **Immersive Intro Screen**: Welcome screen with cinematic animations, glowing effects, and smooth transitions
- **Full-Featured Video Player**: Professional video player for the 1 hour 18 minute film
- **Automatic Interval**: 10-minute interval starting at 30:33 into the film with animated countdown
- **Cinematic Animations**: Smooth fade transitions, pulsing effects, shimmer text, and animated overlays
- **Raspberry Pi Kiosk Mode**: Optimized for unattended operation on Raspberry Pi 5
  - Auto-fullscreen on load
  - Disabled keyboard shortcuts (Escape, Alt+F4) to prevent exiting
  - Hidden mouse cursor for clean presentation
  - Dual display support (HDMI TV + Pi Display 2)
- **Responsive Design**: Works on various screen sizes from mobile to large TV displays
- **Keyboard Controls**: 
  - `Space`: Play/Pause
  - `F`: Toggle Fullscreen
  - `I`: Toggle Interval (for testing)

## Screenshots

### Intro Screen
![Intro Screen](https://github.com/user-attachments/assets/99e3c0b8-c88a-4a53-bc3e-835aca671ec9)
*Welcome screen with animated title, premiere information, and cinema etiquette reminders*

### Video Player
![Video Player](https://github.com/user-attachments/assets/3f6237d9-8a98-4f28-9466-90068577a7b4)
*Full-screen video player with HTML5 controls*

### Interval Screen
![Interval Screen](https://github.com/user-attachments/assets/810a5697-302b-4e3a-964d-76a4297a3192)
*Automated interval with countdown timer and film information*

## Setup

### Standard Web Setup

1. Place your video file named `on-track-to-terror.mp4` in the same directory as `index.html`
2. Open `index.html` in a web browser
3. Click "Begin Screening" to start the premiere experience

### Raspberry Pi Kiosk Mode Setup

For running on a Raspberry Pi 5 in kiosk mode with dual displays (HDMI TV + Pi Display 2):

1. **Clone or download this repository to your Raspberry Pi**
   ```bash
   git clone https://github.com/QuizzityMC/OTTT-Premiere.git
   cd OTTT-Premiere
   ```

2. **Place your video file**
   ```bash
   cp /path/to/your/video.mp4 ./on-track-to-terror.mp4
   ```

3. **Run the installation script**
   ```bash
   chmod +x install-kiosk.sh
   ./install-kiosk.sh
   ```

4. **Reboot your Raspberry Pi**
   ```bash
   sudo reboot
   ```

The system will automatically boot into kiosk mode and start the premiere player in fullscreen.

For detailed Raspberry Pi setup instructions, see [RASPBERRY_PI_SETUP.md](RASPBERRY_PI_SETUP.md)

## Technical Details

- **Film Duration**: 1 hour 18 minutes (78 minutes)
- **Interval Time**: 30 minutes 33 seconds (30:33)
- **Interval Duration**: 10 minutes
- **Production**: Canary Films

### Cinematic Animations

The player features professional cinema-quality animations:
- **Intro Screen**:
  - Gradient background shift animation
  - Slide-in title with shimmer effect
  - Glowing premiere text with pulse animation
  - Fade-in notices with hover effects
  - Pulsing "Begin Screening" button
- **Transitions**:
  - Smooth fade-in/fade-out between screens (1.5s)
  - Delayed screen switching for polished transitions
- **Interval Screen**:
  - Slide-in overlay with fade effect
  - Glowing title with continuous animation
  - Pulsing countdown timer
  - Elegant border and shadow effects

### Raspberry Pi Optimization

- **Hardware Tested**: Raspberry Pi 5 (4GB/8GB)
- **Dual Display Support**: HDMI + DSI (Pi Display 2)
- **GPU Memory**: Configured to 256MB for smooth video playback
- **Auto-start**: Chromium kiosk mode on boot
- **Performance**: Optimized for 1080p video playback

## Files

- `index.html`: Main HTML structure
- `styles.css`: Styling, animations, and visual design
- `player.js`: Video player logic, interval control, and kiosk mode features
- `demo.html`: Demo version with online video for testing
- `demo-player.js`: Demo player script with shorter interval timing
- `install-kiosk.sh`: Automated installation script for Raspberry Pi kiosk mode
- `RASPBERRY_PI_SETUP.md`: Detailed Raspberry Pi setup and configuration guide
- `VIDEO_SETUP.md`: Video file requirements and hosting instructions

## Usage

The player will:
1. Display an animated intro screen with premiere information and cinema etiquette reminders
2. Smoothly transition to the video player when "Begin Screening" is clicked
3. Automatically pause at 30:33 and display an animated interval screen
4. Show a 10-minute countdown with pulsing timer during the interval
5. Automatically resume playback after the interval ends

### Kiosk Mode Features

When running in kiosk mode (enabled by default in `player.js`):
- Automatically enters fullscreen after page load
- Prevents exiting via Escape key or Alt+F4
- Hides mouse cursor for clean presentation
- Disables right-click context menu
- Optimized for Raspberry Pi 5 dual display setup

## Browser Compatibility

Works with modern browsers that support HTML5 video:
- Chrome/Edge
- Firefox
- Safari
- Opera
