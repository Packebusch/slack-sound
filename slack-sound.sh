#!/bin/bash

# Slack Custom Sound Notification Script
# Replaces default Slack notification sounds with custom audio files
# Requires macOS with afplay and log stream utilities

# Default values
SOUND_FILE="${1:-$HOME/Downloads/icq.mp3}"
DEBOUNCE_SECONDS="${2:-2}"

# Function to display usage
show_usage() {
    cat << EOF
Usage: $0 [SOUND_FILE] [DEBOUNCE_SECONDS]

Arguments:
  SOUND_FILE         Path to audio file (default: ~/Downloads/icq.mp3)
  DEBOUNCE_SECONDS   Minimum seconds between plays (default: 2)

Example:
  $0 ~/sounds/notification.mp3 3

Supported formats: MP3, WAV, AIFF, AAC, and other formats supported by afplay
EOF
    exit 0
}

# Show help if requested
if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    show_usage
fi

# Validate sound file exists
if [[ ! -f "$SOUND_FILE" ]]; then
    echo "Error: Sound file not found: $SOUND_FILE" >&2
    echo "Please provide a valid audio file path." >&2
    exit 1
fi

# Validate debounce is a number
if ! [[ "$DEBOUNCE_SECONDS" =~ ^[0-9]+$ ]]; then
    echo "Error: DEBOUNCE_SECONDS must be a positive integer" >&2
    exit 1
fi

echo "Starting Slack notification monitor..."
echo "Sound file: $SOUND_FILE"
echo "Debounce: ${DEBOUNCE_SECONDS}s"
echo "Press Ctrl+C to stop"
echo ""

# Create temporary file to track last play time
TEMP_FILE=$(mktemp)
# Initialize with current time to prevent playing on startup
echo "$(date +%s)" > "$TEMP_FILE"

# Clean up temp file on exit
trap "rm -f $TEMP_FILE" EXIT

# Watch for Slack notifications and play custom sound
log stream --predicate 'subsystem == "com.apple.unc" AND eventMessage CONTAINS "Delivering" AND eventMessage CONTAINS "com.tinyspeck.slackmacgap"' --level info | \
while IFS= read -r line; do
    CURRENT_TIME=$(date +%s)
    LAST_PLAY=$(cat "$TEMP_FILE")
    TIME_DIFF=$((CURRENT_TIME - LAST_PLAY))

    # Only play if debounce period has passed
    if [ $TIME_DIFF -gt $DEBOUNCE_SECONDS ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Slack notification detected, playing sound..."
        afplay "$SOUND_FILE" &
        echo "$CURRENT_TIME" > "$TEMP_FILE"
    fi
done