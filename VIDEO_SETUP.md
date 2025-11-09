# Video File Setup Instructions

To use the "On Track to Terror" video player, you need to place your video file in this directory.

## File Requirements

1. **File Name**: `on-track-to-terror.mp4`
2. **Format**: MP4 (H.264 video codec recommended)
3. **Duration**: 1 hour 18 minutes (78 minutes)
4. **Location**: Same directory as `index.html`

## Supported Video Formats

While the player expects MP4, you can use other formats supported by HTML5 video. If using a different format, update the source tag in `index.html`:

```html
<video id="video-player" controls>
    <source src="your-video-file.webm" type="video/webm">
    <source src="your-video-file.mp4" type="video/mp4">
    Your browser does not support the video tag.
</video>
```

## Testing Without the Full Video

Use `demo.html` to test the player functionality with a sample video. The demo version:
- Uses an online sample video (Big Buck Bunny)
- Triggers the interval at 30 seconds (instead of 30:33)
- Shows a 1-minute interval (instead of 10 minutes)

## Hosting the Player

### Local Testing
1. Place `on-track-to-terror.mp4` in this directory
2. Open `index.html` in a web browser
3. OR run a local server:
   ```bash
   python3 -m http.server 8000
   ```
   Then visit http://localhost:8000

### Production Hosting
- Upload all files to a web server
- Ensure the video file is accessible
- Consider using a CDN for the video file for better streaming performance

## Video Encoding Recommendations

For best compatibility and performance:
- **Video Codec**: H.264
- **Audio Codec**: AAC
- **Container**: MP4
- **Resolution**: 1920x1080 (Full HD) or 1280x720 (HD)
- **Bitrate**: 5-8 Mbps for Full HD, 3-5 Mbps for HD

## Troubleshooting

**Video doesn't load:**
- Check that the file is named exactly `on-track-to-terror.mp4`
- Check that the file is in the same directory as `index.html`
- Open browser console (F12) to see error messages

**Video stutters or buffers:**
- Reduce the video bitrate
- Use a local server instead of opening the file directly
- Consider hosting the video on a CDN

**Interval timing is wrong:**
- The interval triggers at exactly 30 minutes 33 seconds (30:33)
- Ensure your video file is the correct duration
- The player uses `video.currentTime` to detect the interval point
