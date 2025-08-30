import 'dart:async';
import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:cross_file/cross_file.dart';
import 'package:window_manager/window_manager.dart';
import '../config/app_config.dart';
import '../services/video_player_service.dart';
import '../services/file_service.dart';
import '../services/playlist_service.dart';
import '../widgets/video_player_controls.dart';
import '../widgets/playlist_widget.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => VideoPlayerScreenState();
}

class VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late final VideoPlayerService _videoService;
  late final PlaylistService _playlistService;
  String? _currentVideoPath;
  bool _isControlsVisible = true;
  bool _isPlaylistVisible = false;
  bool _isFullscreen = false;
  Timer? _controlsTimer;

  @override
  void initState() {
    super.initState();
    _videoService = VideoPlayerService();
    _videoService.initialize();
    _playlistService = PlaylistService();
    _videoService.setOnVideoEndedCallback(_onVideoEnded);
    _startControlsTimer();
  }

  @override
  void dispose() {
    _controlsTimer?.cancel();
    _videoService.dispose();
    _playlistService.dispose();
    super.dispose();
  }

  void _startControlsTimer() {
    _controlsTimer?.cancel();
    _controlsTimer = Timer(AppConfig.controlsHideDelay, () {
      if (mounted) {
        setState(() {
          _isControlsVisible = false;
        });
      }
    });
  }

  void _showControls() {
    setState(() {
      _isControlsVisible = true;
    });
    _startControlsTimer();
  }

  void _toggleFullscreen() async {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });
    
    if (_isFullscreen) {
      await windowManager.setFullScreen(true);
    } else {
      await windowManager.setFullScreen(false);
    }
  }

  Future<void> _openVideoFile(String videoPath) async {
    try {
      setState(() {
        _currentVideoPath = videoPath;
      });
      
      // Load playlist and video
      await _playlistService.loadPlaylistFromFile(videoPath);
      await _videoService.openVideo(videoPath);
      
      if (mounted) {
        _showSuccessMessage('Video loaded: ${FileService.getFileName(videoPath)}');
        _showControls(); // Show controls when video loads
      }
    } catch (e) {
      if (mounted) {
        _showErrorMessage('Error opening video: $e');
      }
    }
  }

  Future<void> _pickVideoFile() async {
    try {
      final videoPath = await FileService.pickVideoFile();
      if (videoPath != null) {
        await _openVideoFile(videoPath);
      }
    } catch (e) {
      if (mounted) {
        _showErrorMessage('Error selecting file: $e');
      }
    }
  }

  void _handleDroppedFiles(List<XFile> files) {
    final videoPath = FileService.getVideoFromDroppedFiles(files);
    if (videoPath != null) {
      _openVideoFile(videoPath);
    } else {
      _showWarningMessage('Please drop a video file');
    }
  }
  
  void _onVideoEnded() {
    final nextVideoPath = _playlistService.getNextFile();
    if (nextVideoPath != null) {
      _openVideoFile(nextVideoPath);
    }
  }
  
  void _togglePlaylist() {
    setState(() {
      _isPlaylistVisible = !_isPlaylistVisible;
    });
    _showControls(); // Show controls when toggling playlist
    
    // Force refresh playlist data when showing
    if (_isPlaylistVisible && _currentVideoPath != null) {
      _playlistService.loadPlaylistFromFile(_currentVideoPath!);
    }
  }
  
  // Public method for external access (menu, shortcuts)
  void togglePlaylist() {
    _togglePlaylist();
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: AppConfig.snackBarDuration,
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showWarningMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: DropTarget(
        onDragDone: (details) => _handleDroppedFiles(details.files),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenHeight = constraints.maxHeight;
            final bottomZoneHeight = screenHeight * 0.2; // Bottom 20%
            
            return GestureDetector(
              onTap: _showControls,
              behavior: HitTestBehavior.opaque,
              child: MouseRegion(
                onHover: (event) {
                  final mouseY = event.localPosition.dy;
                  final bottomZoneStart = screenHeight - bottomZoneHeight;
                  
                  if (mouseY >= bottomZoneStart) {
                    // Mouse in bottom 20%
                    _showControls();
                  } else {
                    // Mouse not in bottom 20% - hide controls after delay
                    _controlsTimer?.cancel();
                    _controlsTimer = Timer(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        setState(() {
                          _isControlsVisible = false;
                        });
                      }
                    });
                  }
                },
                onExit: (_) {
                  // Hide controls when mouse leaves the window
                  _controlsTimer?.cancel();
                  _controlsTimer = Timer(const Duration(milliseconds: 300), () {
                    if (mounted) {
                      setState(() {
                        _isControlsVisible = false;
                      });
                    }
                  });
                },
                child: Stack(
                  children: [
                    // Video player
                    _buildVideoPlayer(),
                    // Controls overlay
                    _buildControlsOverlay(),
                    // Playlist
                    if (_isPlaylistVisible)
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: PlaylistWidget(
                          playlistService: _playlistService,
                          onVideoSelected: _openVideoFile,
                          isVisible: _isPlaylistVisible,
                          onClose: _togglePlaylist,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Center(
      child: _currentVideoPath != null
          ? Video(
              controller: _videoService.controller,
              fit: BoxFit.contain,
            )
          : _buildWelcomeScreen(),
    );
  }

  Widget _buildWelcomeScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.video_library,
          size: 80,
          color: Colors.white54,
        ),
        const SizedBox(height: 16),
        const Text(
          AppConfig.appName,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          AppConfig.appDescription,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Drag & Drop a video file or click to select',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white60,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          onPressed: _pickVideoFile,
          icon: const Icon(Icons.folder_open),
          label: const Text('Select Video File'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildControlsOverlay() {
    return AnimatedOpacity(
      opacity: _isControlsVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.3),
              Colors.transparent,
              Colors.transparent,
              Colors.black.withValues(alpha: 0.6),
            ],
          ),
        ),
        child: Column(
          children: [
            const Spacer(),
            if (_currentVideoPath != null)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: VideoPlayerControls(
                  player: _videoService.player,
                  onPlaylistToggle: _togglePlaylist,
                  isPlaylistVisible: _isPlaylistVisible,
                  onFileSelect: _pickVideoFile,
                  onFullscreenToggle: _toggleFullscreen,
                  isFullscreen: _isFullscreen,
                ),
              ),
          ],
        ),
      ),
    );
  }
}