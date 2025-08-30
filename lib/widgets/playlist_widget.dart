import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../services/playlist_service.dart';

class PlaylistWidget extends StatelessWidget {
  final PlaylistService playlistService;
  final Function(String) onVideoSelected;
  final bool isVisible;
  final VoidCallback? onClose;

  const PlaylistWidget({
    super.key,
    required this.playlistService,
    required this.onVideoSelected,
    required this.isVisible,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return const SizedBox.shrink();
    }

    return Container(
      width: AppConfig.playlistWidth,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.95),
        border: const Border(
          left: BorderSide(color: Colors.white24, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Colors.black54,
              border: Border(
                bottom: BorderSide(color: Colors.white24, width: 1),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.playlist_play,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Playlist',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                StreamBuilder<List<PlaylistItem>>(
                  stream: playlistService.playlistStream,
                  initialData: playlistService.playlist, // Add initial data here too
                  builder: (context, snapshot) {
                    final count = snapshot.hasData ? snapshot.data!.length : playlistService.playlist.length;
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$count',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
                const Spacer(),
                // Close button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: IconButton(
                    onPressed: onClose,
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                    tooltip: 'Close Playlist',
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    padding: const EdgeInsets.all(4),
                  ),
                ),
              ],
            ),
          ),
          // File list
          Expanded(
            child: StreamBuilder<List<PlaylistItem>>(
              stream: playlistService.playlistStream,
              initialData: playlistService.playlist, // Add initial data
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white54,
                    ),
                  );
                }
                
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.playlist_remove,
                          color: Colors.white54,
                          size: 48,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No videos in playlist',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                final files = snapshot.data!;
                
                return ListView.builder(
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    final file = files[index];
                    
                    return Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: file.isCurrentlyPlaying 
                            ? Colors.blue.withValues(alpha: 0.3)
                            : Colors.transparent,
                        border: const Border(
                          bottom: BorderSide(color: Colors.white12, width: 0.5),
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            playlistService.selectFile(index);
                            onVideoSelected(file.filePath);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Row(
                              children: [
                                // Index or play indicator
                                Container(
                                  width: 30,
                                  alignment: Alignment.center,
                                  child: file.isCurrentlyPlaying
                                      ? const Icon(
                                          Icons.play_arrow,
                                          color: Colors.blue,
                                          size: 20,
                                        )
                                      : Text(
                                          '${index + 1}',
                                          style: const TextStyle(
                                            color: Colors.white54,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                ),
                                const SizedBox(width: 12),
                                // File name
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        file.displayName,
                                        style: TextStyle(
                                          color: file.isCurrentlyPlaying ? Colors.white : Colors.white.withOpacity(0.9),
                                          fontSize: 13,
                                          fontWeight: file.isCurrentlyPlaying ? FontWeight.w600 : FontWeight.normal,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (file.isCurrentlyPlaying)
                                        Text(
                                          'Now Playing',
                                          style: TextStyle(
                                            color: Colors.blue.withValues(alpha: 0.8),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}