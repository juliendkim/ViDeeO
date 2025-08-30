**Language / 언어**: [English](README.md) | [한국어](README.ko.md)

# ViDeeO

**ViDeeO** is a cross-platform video player app based on Flutter and MPV.

![Platform](https://img.shields.io/badge/Platform-Flutter-blue)
![License](https://img.shields.io/badge/License-MIT-green)

## Features

### 🎬 **Video Playback**
- High-quality video playback based on MPV
- Hardware acceleration support
- Support for various video formats

### 🎮 **Intuitive Controls**
- Play/Pause
- 10-second forward/backward seek
- Draggable progress bar
- Real-time volume control
- Auto-hide/show controls

### 📋 **Playlist Features**
- **Smart Playlist**: Automatically loads all video files in the folder when a video is selected
- **Auto-sort**: Alphabetically sorted by filename
- **Toggle Sidebar**: Slide panel on the right side of the screen
- **Auto Next Play**: Automatically plays the next file when the current video ends
- **One-click Play**: Instantly play files by clicking in the playlist
- **Visual Indicator**: Highlights the currently playing file

### 🖱️ **Convenient File Management**
- Drag and drop support
- Integrated file picker
- Real-time file validation

### 🖼️ **Fullscreen & Window Management**
- Native macOS fullscreen support
- Mouse-based control show/hide (bottom 20% screen area)
- Auto control timeout (3 seconds)

### 📱 **Multi-platform Support**
- macOS
- Windows
- Linux  
- iOS
- Android

### 🎨 **Modern UI**
- Material Design 3 based
- Dark theme UI
- Smooth animations
- Intuitive icons

## Screenshots

### Main Screen
When you first launch the app, you'll see the "ViDeeO" logo with a button to select video files.

### Video Playback
While a video is playing, touch the screen to reveal the controls, which automatically hide after 3 seconds.

### Playlist
Click the playlist icon in the top toolbar to display the video list on the right side of the screen. The currently playing file is highlighted in blue, and you can click other files in the list to play them instantly.

## Installation & Setup

### Requirements

- Flutter 3.9.0 or higher
- Dart 3.0.0 or higher
- Platform-specific development environment setup

### Installation

1. Clone the repository
```bash
git clone https://github.com/juliendkim/ViDeeO.git
cd ViDeeO
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
# macOS
flutter run -d macos

# Windows
flutter run -d windows

# Linux
flutter run -d linux

# iOS (Simulator)
flutter run -d ios

# Android
flutter run -d android
```

## Usage

### Basic Playback
1. **File Selection**: Click the "Select Video File" button or drag and drop video files
2. **Playback Control**: Click the screen to show/hide the control panel
3. **Navigation**: Drag the progress bar to move to desired position

### Playlist Features
1. **Open Playlist**: Click the 📋 icon in the top toolbar
2. **Auto Load**: When you select a video file, all video files in that folder are automatically added to the playlist
3. **Manual Selection**: Click the desired file in the playlist to play
4. **Auto Play**: When the current video ends, the next file plays automatically

### Keyboard Shortcuts
- **Spacebar**: Play/Pause
- **←/→**: 10-second forward/backward
- **↑/↓**: Volume control

## Supported Video Formats

Leveraging MPV's powerful decoding capabilities, we support various video formats:

- MP4
- AVI
- MKV
- MOV
- WMV
- FLV
- WebM
- And many more...

## Technologies Used

### Flutter Packages
- `media_kit`: MPV-based media playback engine
- `media_kit_video`: Video rendering and UI controls
- `media_kit_libs_video`: Platform-specific MPV libraries
- `file_picker`: File selection dialogs
- `desktop_drop`: Drag and drop support
- `path_provider`: System directory access
- `window_manager`: macOS/Windows window management (fullscreen, title bar)
- `flutter_launcher_icons`: Cross-platform app icon generation

### Architecture
- **UI Layer**: Flutter Material Design 3
- **Media Layer**: MediaKit (libmpv)
- **Platform Layer**: Platform-specific native implementations

## Development

### Project Structure

```
lib/
├── main.dart                    # App entry point, MediaKit initialization, window_manager setup
├── config/
│   ├── app_config.dart         # App settings and constants (supported file formats, UI settings)
│   └── app_theme.dart          # Material Design 3 dark theme
├── services/
│   ├── file_service.dart       # File handling (selection, drag&drop, folder scan, validation)
│   ├── video_player_service.dart # Video playback engine (MediaKit wrapper, auto next play)
│   └── playlist_service.dart   # Playlist management (StreamController, navigation)
├── widgets/
│   ├── video_player_controls.dart # Playback controls (play/pause, volume, progress, fullscreen)
│   └── playlist_widget.dart    # Playlist UI (toggle sidebar, current play highlight)
└── screens/
    └── video_player_screen.dart   # Main screen (MouseRegion-based control display, drag&drop)

assets/
└── icons/
    ├── app_icon.png            # App icon (PNG, for all platforms)
    └── app_icon.svg            # App icon source (vector)

android/                         # Android platform code and generated icons
ios/                             # iOS platform code and generated icons  
macos/                           # macOS platform code and generated icons
windows/                         # Windows platform code and generated icons
linux/                           # Linux platform code
```

### Architecture Design

#### 📁 **Config Layer**
- `AppConfig`: App-wide settings, constants, supported file format definitions
- `AppTheme`: Material Design 3 based theme configuration

#### 🛠️ **Service Layer**
- `FileService`: File system operations (file selection, folder scanning, validation)
- `VideoPlayerService`: MPV-based video playback engine wrapper, auto next play callbacks
- `PlaylistService`: Playlist management, file navigation, state streaming

#### 🎨 **Widget Layer**
- `VideoPlayerControls`: Reusable media control components
- `PlaylistWidget`: Toggle playlist sidebar with animations
- Each widget follows single responsibility principle

#### 📱 **Screen Layer**
- `VideoPlayerScreen`: Main video playback screen and state management
- Handles drag & drop, touch gestures, playlist toggle
- Auto next play and playlist integration

### Build

```bash
# Debug build
flutter build [platform] --debug

# Release build
flutter build [platform] --release
```

## License

This project is distributed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Before sending a Pull Request, please ensure:

1. Code passes `flutter analyze`
2. All tests pass (`flutter test`)
3. Proper documentation for new features

## Issue Reporting

If you have bugs or feature requests, please report them on the [Issues](https://github.com/juliendkim/ViDeeO/issues) page.

## Acknowledgments

- [MediaKit](https://github.com/media-kit/media-kit) - Thanks to the developers for providing an excellent Flutter video playback solution.
- [MPV](https://mpv.io/) - Thanks to the MPV team for providing a powerful media player engine.

---

**ViDeeO** - *Simple, Powerful, Cross-platform Video Player*
