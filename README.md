# Slack Custom Sound Notifications

A simple macOS script that replaces Slack's default notification sounds with your own custom audio files. Perfect for nostalgic sound effects like ICQ, MSN Messenger, or any sound of your choice.

## Features

- Replace Slack notification sounds with any audio file
- Built-in debouncing to prevent sound spam
- Configurable sound file and debounce timing
- Lightweight and runs in the background
- Works with the native Slack macOS app

## Prerequisites

- macOS (tested on macOS 10.15+)
- Slack desktop app for macOS
- Audio file in a supported format (MP3, WAV, AIFF, AAC, etc.)

## Installation

1. Clone this repository:
```bash
git clone https://github.com/yourusername/slack-custom-sounds.git
cd slack-custom-sounds
```

2. Make the script executable:
```bash
chmod +x slack-sound.sh
```

3. Download or prepare your custom notification sound file

## Usage

### Basic Usage

Run the script with default settings (looks for `~/Downloads/icq.mp3`):
```bash
./slack-sound.sh
```

### Custom Sound File

Specify your own sound file:
```bash
./slack-sound.sh ~/sounds/notification.mp3
```

### Custom Debounce Time

Adjust the minimum time between sound plays (in seconds):
```bash
./slack-sound.sh ~/sounds/notification.mp3 3
```

### Run in Background

To keep the script running in the background:
```bash
nohup ./slack-sound.sh ~/sounds/notification.mp3 > /dev/null 2>&1 &
```

### Run at Startup

To automatically start the script when you log in:

1. Create a launch agent plist file at `~/Library/LaunchAgents/com.slacksound.plist`:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.slacksound</string>
    <key>ProgramArguments</key>
    <array>
        <string>/path/to/slack-sound.sh</string>
        <string>/path/to/your/sound.mp3</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/tmp/slack-sound.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/slack-sound.error.log</string>
</dict>
</plist>
```

2. Load the launch agent:
```bash
launchctl load ~/Library/LaunchAgents/com.slacksound.plist
```

## Where to Get Sounds

### Popular Sound Packs

- **ICQ Classic**: Search for "ICQ uh oh sound" online
- **MSN Messenger**: Available in various sound pack archives
- **Classic System Sounds**: Check macOS sound libraries
- **Custom Sounds**: Use any audio file converter to create MP3/WAV files

### Creating Your Own

Convert any audio file using online tools or command line:
```bash
ffmpeg -i input.wav -acodec libmp3lame output.mp3
```

## Troubleshooting

### Script says "Sound file not found"
Make sure the path to your sound file is correct and the file exists:
```bash
ls -l ~/Downloads/icq.mp3
```

### No sound plays on notifications
1. Check that Slack notifications are enabled in System Preferences
2. Verify the script is running: `ps aux | grep slack-sound`
3. Test your sound file manually: `afplay ~/Downloads/icq.mp3`
4. Ensure Slack is not in Do Not Disturb mode

### Sounds play multiple times
Increase the debounce time (third argument):
```bash
./slack-sound.sh ~/sounds/notification.mp3 5
```

### Permission Issues
The script needs permission to read system logs. macOS may prompt for permission on first run.

## How It Works

The script monitors macOS system logs for Slack notification events using the `log stream` command. When a Slack notification is detected, it plays your custom sound using `afplay`. A debounce mechanism prevents the sound from playing too frequently.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - see LICENSE file for details

## Acknowledgments

Inspired by the need for better notification sounds and nostalgia for classic messaging apps.
