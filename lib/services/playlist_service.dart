import 'dart:async';
import 'dart:io';
import '../services/file_service.dart';

class PlaylistItem {
  final String filePath;
  final String displayName;
  final bool isCurrentlyPlaying;
  
  PlaylistItem({
    required this.filePath,
    required this.displayName,
    this.isCurrentlyPlaying = false,
  });
  
  PlaylistItem copyWith({
    String? filePath,
    String? displayName,
    bool? isCurrentlyPlaying,
  }) {
    return PlaylistItem(
      filePath: filePath ?? this.filePath,
      displayName: displayName ?? this.displayName,
      isCurrentlyPlaying: isCurrentlyPlaying ?? this.isCurrentlyPlaying,
    );
  }
}

class PlaylistService {
  final StreamController<List<PlaylistItem>> _playlistController = 
      StreamController<List<PlaylistItem>>.broadcast();
  
  List<PlaylistItem> _playlist = [];
  int _currentIndex = -1;
  String? _currentFilePath;
  
  Stream<List<PlaylistItem>> get playlistStream => _playlistController.stream.asBroadcastStream();
  List<PlaylistItem> get playlist => List.unmodifiable(_playlist);
  int get currentIndex => _currentIndex;
  String? get currentFilePath => _currentFilePath;
  
  Future<void> loadPlaylistFromFile(String videoFilePath) async {
    try {
      // Get directory
      final file = File(videoFilePath);
      final directory = file.parent;
      
      // Get all video files in directory
      final entities = await directory.list().toList();
      final videoFiles = <String>[];
      
      for (final entity in entities) {
        if (entity is File) {
          final path = entity.path;
          if (FileService.isVideoFile(path)) {
            videoFiles.add(path);
          }
        }
      }
      
      // Sort files
      videoFiles.sort();
      
      // Create playlist items
      _playlist = videoFiles.map((path) => PlaylistItem(
        filePath: path,
        displayName: FileService.getFileNameWithoutExtension(path),
        isCurrentlyPlaying: path == videoFilePath,
      )).toList();
      
      // Set current index
      _currentIndex = videoFiles.indexOf(videoFilePath);
      _currentFilePath = videoFilePath;
      
      // Always add to stream controller, regardless of visibility
      if (!_playlistController.isClosed) {
        _playlistController.add(_playlist);
      }
      
    } catch (e) {
      // Silent error handling
    }
  }
  
  void selectFile(int index) {
    if (index >= 0 && index < _playlist.length) {
      _currentIndex = index;
      _currentFilePath = _playlist[index].filePath;
      
      // Update playlist items
      _playlist = _playlist.asMap().entries.map((entry) {
        final i = entry.key;
        final item = entry.value;
        return item.copyWith(isCurrentlyPlaying: i == index);
      }).toList();
      
      if (!_playlistController.isClosed) {
        _playlistController.add(_playlist);
      }
    }
  }
  
  String? getNextFile() {
    if (_playlist.isEmpty) return null;
    
    final nextIndex = _currentIndex + 1;
    if (nextIndex < _playlist.length) {
      selectFile(nextIndex);
      return _playlist[nextIndex].filePath;
    }
    
    return null;
  }
  
  String? getPreviousFile() {
    if (_playlist.isEmpty) return null;
    
    final prevIndex = _currentIndex - 1;
    if (prevIndex >= 0) {
      selectFile(prevIndex);
      return _playlist[prevIndex].filePath;
    }
    
    return null;
  }
  
  void clear() {
    _playlist.clear();
    _currentIndex = -1;
    _currentFilePath = null;
    if (!_playlistController.isClosed) {
      _playlistController.add(_playlist);
    }
  }
  
  void dispose() {
    _playlistController.close();
  }
}