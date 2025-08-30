import 'dart:async';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import '../services/file_service.dart';

class VideoPlayerService {
  late final Player _player;
  late final VideoController _controller;
  StreamSubscription? _positionSubscription;
  Function()? _onVideoEnded;
  
  Player get player => _player;
  VideoController get controller => _controller;
  
  void initialize() {
    _player = Player();
    _controller = VideoController(_player);
    _setupVideoEndListener();
  }
  
  void setOnVideoEndedCallback(Function() callback) {
    _onVideoEnded = callback;
  }
  
  void _setupVideoEndListener() {
    _positionSubscription = _player.stream.position.listen((position) {
      final duration = _player.state.duration;
      if (duration != Duration.zero && position >= duration - const Duration(milliseconds: 500)) {
        // Video has ended (within 500ms of the end to account for timing issues)
        if (_onVideoEnded != null) {
          print('Video ended, calling callback');
          _onVideoEnded!();
        }
      }
    });
  }
  
  Future<void> openVideo(String videoPath) async {
    print('Opening video file: $videoPath');
    
    // Check if file exists
    if (!await FileService.fileExists(videoPath)) {
      throw Exception('File does not exist: $videoPath');
    }
    
    print('Opening video with media player...');
    await _player.open(Media(videoPath));
    print('Video opened successfully');
  }
  
  void playOrPause() {
    _player.playOrPause();
  }
  
  void seek(Duration position) {
    _player.seek(position);
  }
  
  void setVolume(double volume) {
    _player.setVolume(volume);
  }
  
  void dispose() {
    _positionSubscription?.cancel();
    _player.dispose();
  }
}
