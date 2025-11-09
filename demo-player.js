// Video Player Controller for "On Track to Terror" Premiere (DEMO VERSION)
// This demo uses a shorter interval time (30 seconds) for testing purposes

// Configuration - DEMO: Interval at 30 seconds instead of 30:33
const INTERVAL_START_TIME = 30; // 30 seconds for demo (production: 30 * 60 + 33)
const INTERVAL_DURATION = 60; // 60 seconds for demo (production: 10 * 60)
const KIOSK_MODE = true; // Enable kiosk mode features

// DOM Elements
const introScreen = document.getElementById('intro-screen');
const playerScreen = document.getElementById('player-screen');
const startButton = document.getElementById('start-button');
const videoPlayer = document.getElementById('video-player');
const intervalOverlay = document.getElementById('interval-overlay');
const intervalTimer = document.getElementById('interval-timer');

// State
let intervalShown = false;
let intervalStartTimestamp = null;
let intervalCountdown = null;

// Kiosk mode: Auto-enter fullscreen on load
if (KIOSK_MODE) {
    window.addEventListener('load', () => {
        setTimeout(() => {
            if (document.documentElement.requestFullscreen) {
                document.documentElement.requestFullscreen().catch(err => {
                    console.log('Fullscreen request failed:', err);
                });
            }
        }, 1000);
    });
}

// Event Listeners
startButton.addEventListener('click', startScreening);
videoPlayer.addEventListener('timeupdate', checkForInterval);

/**
 * Start the screening - hide intro and show video player with smooth transition
 */
function startScreening() {
    // Add fade-out animation to intro screen
    introScreen.classList.add('fade-out');
    
    // Wait for fade-out animation to complete before switching screens
    setTimeout(() => {
        introScreen.classList.remove('active', 'fade-out');
        playerScreen.classList.add('active');
        videoPlayer.play();
    }, 1000);
}

/**
 * Check if we've reached the interval time
 */
function checkForInterval() {
    const currentTime = videoPlayer.currentTime;
    
    // Check if we've reached the interval point and haven't shown it yet
    if (currentTime >= INTERVAL_START_TIME && !intervalShown) {
        showInterval();
    }
}

/**
 * Show the interval overlay and pause the video
 */
function showInterval() {
    intervalShown = true;
    videoPlayer.pause();
    intervalOverlay.classList.add('active');
    
    // Record when the interval started
    intervalStartTimestamp = Date.now();
    
    // Start the countdown timer
    startIntervalCountdown();
}

/**
 * Hide the interval overlay and resume the video
 */
function hideInterval() {
    intervalOverlay.classList.remove('active');
    videoPlayer.play();
    
    // Clear the countdown if it's still running
    if (intervalCountdown) {
        clearInterval(intervalCountdown);
        intervalCountdown = null;
    }
}

/**
 * Start the countdown timer for the interval
 */
function startIntervalCountdown() {
    let remainingSeconds = INTERVAL_DURATION;
    updateTimerDisplay(remainingSeconds);
    
    intervalCountdown = setInterval(() => {
        const elapsed = Math.floor((Date.now() - intervalStartTimestamp) / 1000);
        remainingSeconds = INTERVAL_DURATION - elapsed;
        
        if (remainingSeconds <= 0) {
            clearInterval(intervalCountdown);
            intervalCountdown = null;
            hideInterval();
        } else {
            updateTimerDisplay(remainingSeconds);
        }
    }, 1000);
}

/**
 * Update the timer display with remaining time
 * @param {number} seconds - Remaining seconds
 */
function updateTimerDisplay(seconds) {
    const minutes = Math.floor(seconds / 60);
    const secs = seconds % 60;
    intervalTimer.textContent = `${minutes}:${secs.toString().padStart(2, '0')}`;
}

/**
 * Format time in seconds to MM:SS
 * @param {number} seconds - Time in seconds
 * @returns {string} Formatted time string
 */
function formatTime(seconds) {
    const mins = Math.floor(seconds / 60);
    const secs = Math.floor(seconds % 60);
    return `${mins}:${secs.toString().padStart(2, '0')}`;
}

// Keyboard controls for testing
document.addEventListener('keydown', (e) => {
    // In kiosk mode, disable certain keys to prevent exiting
    if (KIOSK_MODE) {
        // Prevent escape key
        if (e.key === 'Escape') {
            e.preventDefault();
            return;
        }
        // Prevent Alt+F4, Ctrl+W, etc.
        if ((e.altKey && e.key === 'F4') || (e.ctrlKey && e.key === 'w')) {
            e.preventDefault();
            return;
        }
    }
    
    // Press 'I' to toggle interval (for testing)
    if (e.key === 'i' || e.key === 'I') {
        if (intervalOverlay.classList.contains('active')) {
            hideInterval();
        } else {
            showInterval();
        }
    }
    
    // Press 'Space' to play/pause
    if (e.key === ' ' && !intervalOverlay.classList.contains('active')) {
        e.preventDefault();
        if (videoPlayer.paused) {
            videoPlayer.play();
        } else {
            videoPlayer.pause();
        }
    }
    
    // Press 'F' for fullscreen
    if (e.key === 'f' || e.key === 'F') {
        if (document.fullscreenElement) {
            document.exitFullscreen();
        } else {
            document.documentElement.requestFullscreen();
        }
    }
});

// Prevent context menu in kiosk mode
if (KIOSK_MODE) {
    document.addEventListener('contextmenu', (e) => {
        e.preventDefault();
        return false;
    });
}

// Log video metadata when loaded
videoPlayer.addEventListener('loadedmetadata', () => {
    console.log('DEMO MODE: Interval starts at 30 seconds instead of 30:33');
    console.log('DEMO MODE: Interval duration is 1 minute instead of 10 minutes');
    console.log('Video duration:', formatTime(videoPlayer.duration));
    console.log('Interval will start at:', formatTime(INTERVAL_START_TIME));
});

// Error handling
videoPlayer.addEventListener('error', (e) => {
    console.error('Video error:', e);
    alert('Error loading video. Please check your internet connection.');
});

console.log('Video player initialized for "On Track to Terror" premiere (DEMO MODE)');
console.log('Controls: Space = Play/Pause, F = Fullscreen, I = Toggle Interval (testing)');
