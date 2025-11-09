# OTTT-Premiere
The video premiere and cinema experience player for the film Premiere of "On Track to Terror"

## Features

- **Intro Screen**: Welcome screen explaining this is the world premiere, with cinema etiquette reminders
- **Video Player**: Full-featured video player for the 1 hour 18 minute film
- **Automatic Interval**: 10-minute interval starting at 30:33 into the film
- **Responsive Design**: Works on various screen sizes
- **Keyboard Controls**: 
  - `Space`: Play/Pause
  - `F`: Toggle Fullscreen
  - `I`: Toggle Interval (for testing)

## Setup

1. Place your video file named `on-track-to-terror.mp4` in the same directory as `index.html`
2. Open `index.html` in a web browser
3. Click "Begin Screening" to start the premiere experience

## Technical Details

- **Film Duration**: 1 hour 18 minutes (78 minutes)
- **Interval Time**: 30 minutes 33 seconds (30:33)
- **Interval Duration**: 10 minutes
- **Production**: Canary Films

## Files

- `index.html`: Main HTML structure
- `styles.css`: Styling and visual design
- `player.js`: Video player logic and interval control

## Usage

The player will:
1. Display an intro screen with premiere information and reminders
2. Start playing the video when "Begin Screening" is clicked
3. Automatically pause at 30:33 and display an interval screen
4. Show a 10-minute countdown during the interval
5. Automatically resume playback after the interval ends

## Browser Compatibility

Works with modern browsers that support HTML5 video:
- Chrome/Edge
- Firefox
- Safari
- Opera
