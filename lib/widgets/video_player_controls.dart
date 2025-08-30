import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import '../config/app_config.dart';

class VideoPlayerControls extends StatefulWidget {
  final Player player;
  final VoidCallback? onPlaylistToggle;
  final bool isPlaylistVisible;
  final VoidCallback? onFileSelect;
  final VoidCallback? onFullscreenToggle;
  final bool isFullscreen;

  const VideoPlayerControls({
    super.key, 
    required this.player,
    this.onPlaylistToggle,
    this.isPlaylistVisible = false,
    this.onFileSelect,
    this.onFullscreenToggle,
    this.isFullscreen = false,
  });

  @override
  State<VideoPlayerControls> createState() => _VideoPlayerControlsState();
}

class _VideoPlayerControlsState extends State<VideoPlayerControls> {
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  double _volume = 1.0;

  @override
  void initState() {
    super.initState();
    _initializeListeners();
  }

  void _initializeListeners() {
    widget.player.stream.playing.listen((playing) {
      if (mounted) {
        setState(() {
          _isPlaying = playing;
        });
      }
    });
    
    widget.player.stream.position.listen((position) {
      if (mounted) {
        setState(() {
          _position = position;
        });
      }
    });
    
    widget.player.stream.duration.listen((duration) {
      if (mounted) {
        setState(() {
          _duration = duration;
        });
      }
    });
    
    widget.player.stream.volume.listen((volume) {
      if (mounted) {
        setState(() {
          _volume = volume / 100;
        });
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void _onSeekBackward() {
    final newPosition = _position - AppConfig.seekDuration;
    widget.player.seek(newPosition < Duration.zero ? Duration.zero : newPosition);
  }

  void _onSeekForward() {
    final newPosition = _position + AppConfig.seekDuration;
    widget.player.seek(newPosition > _duration ? _duration : newPosition);
  }

  void _onVolumeToggle() {
    widget.player.setVolume(_volume == 0 ? 100 : 0);
  }

  void _onVolumeChange(double value) {
    widget.player.setVolume((value * 100).round().toDouble());
  }

  void _onProgressChange(double value) {
    final position = Duration(
      milliseconds: (value * _duration.inMilliseconds).round(),
    );
    widget.player.seek(position);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress bar
          Row(
            children: [
              Text(
                _formatDuration(_position),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    trackHeight: 4,
                  ),
                  child: Slider(
                    value: _duration.inMilliseconds > 0
                        ? _position.inMilliseconds / _duration.inMilliseconds
                        : 0.0,
                    onChanged: _onProgressChange,
                    activeColor: Colors.white,
                    inactiveColor: Colors.white30,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatDuration(_duration),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Volume control
              Row(
                children: [
                  IconButton(
                    onPressed: _onVolumeToggle,
                    icon: Icon(
                      _volume == 0 ? Icons.volume_off : Icons.volume_up,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 4),
                        trackHeight: 2,
                      ),
                      child: Slider(
                        value: _volume,
                        onChanged: _onVolumeChange,
                        activeColor: Colors.white,
                        inactiveColor: Colors.white30,
                      ),
                    ),
                  ),
                ],
              ),
              // Seek backward
              IconButton(
                onPressed: _onSeekBackward,
                icon: const Icon(Icons.replay_10, color: Colors.white, size: 32),
              ),
              // Play/Pause
              IconButton(
                onPressed: widget.player.playOrPause,
                icon: Icon(
                  _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                  color: Colors.white,
                  size: 48,
                ),
              ),
              // Seek forward
              IconButton(
                onPressed: _onSeekForward,
                icon: const Icon(Icons.forward_10, color: Colors.white, size: 32),
              ),
              // File select
              IconButton(
                onPressed: widget.onFileSelect,
                icon: const Icon(
                  Icons.folder_open,
                  color: Colors.white,
                  size: 32,
                ),
                tooltip: 'Select Video File',
              ),
              // Playlist toggle
              Container(
                decoration: BoxDecoration(
                  color: widget.isPlaylistVisible 
                      ? Colors.blue.withValues(alpha: 0.7) 
                      : Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: widget.isPlaylistVisible ? Colors.blue : Colors.white30,
                    width: 2,
                  ),
                ),
                child: IconButton(
                  onPressed: widget.onPlaylistToggle,
                  icon: Icon(
                    widget.isPlaylistVisible ? Icons.playlist_remove : Icons.playlist_play,
                    color: Colors.white,
                    size: 32,
                  ),
                  tooltip: widget.isPlaylistVisible ? 'Hide Playlist' : 'Show Playlist',
                ),
              ),
              // Fullscreen
              IconButton(
                onPressed: widget.onFullscreenToggle,
                icon: Icon(
                  widget.isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
                  color: Colors.white,
                  size: 32,
                ),
                tooltip: widget.isFullscreen ? 'Exit Fullscreen' : 'Enter Fullscreen',
              ),
            ],
          ),
        ],
      ),
    );
  }
}