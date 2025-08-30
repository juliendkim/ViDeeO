class AppConfig {
  static const String appName = 'ViDeeO';
  static const String appDescription = 'MPV-based Video Player';
  
  // Supported video file extensions
  static const List<String> supportedVideoExtensions = [
    '.mp4',
    '.avi', 
    '.mkv',
    '.mov',
    '.wmv',
    '.flv',
    '.webm',
    '.m4v',
    '.3gp',
    '.ts',
    '.mts',
    '.m2ts'
  ];
  
  // UI Constants
  static const Duration controlsHideDelay = Duration(seconds: 3);
  static const Duration seekDuration = Duration(seconds: 10);
  static const Duration snackBarDuration = Duration(seconds: 2);
  
  // Playlist Constants
  static const double playlistWidth = 300.0;
  static const double playlistItemHeight = 56.0;
  static const int maxPlaylistItemNameLength = 40;
}
