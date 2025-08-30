import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:window_manager/window_manager.dart';
import 'config/app_config.dart';
import 'config/app_theme.dart';
import 'screens/video_player_screen.dart';

void main() async {
  // Initialize MediaKit and WindowManager
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  MediaKit.ensureInitialized();
  
  runApp(const ViDeeOApp());
}

class ViDeeOApp extends StatefulWidget {
  const ViDeeOApp({super.key});

  @override
  State<ViDeeOApp> createState() => _ViDeeOAppState();
}

class _ViDeeOAppState extends State<ViDeeOApp> {
  final GlobalKey<VideoPlayerScreenState> _videoPlayerKey = GlobalKey<VideoPlayerScreenState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyP): const TogglePlaylistIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            TogglePlaylistIntent: CallbackAction<TogglePlaylistIntent>(
              onInvoke: (TogglePlaylistIntent intent) {
                _videoPlayerKey.currentState?.togglePlaylist();
                return null;
              },
            ),
          },
          child: PlatformMenuBar(
            menus: <PlatformMenuItem>[
              // App menu is provided automatically by Flutter on macOS.
              PlatformMenu(
                label: 'File',
                menus: const <PlatformMenuItem>[
                  // Removed incompatible menu items
                ],
              ),
              PlatformMenu(
                label: 'Edit',
                menus: const <PlatformMenuItem>[
                  // Removed incompatible menu items
                ],
              ),
              PlatformMenu(
                label: 'View',
                menus: <PlatformMenuItem>[
                  const PlatformMenuItemGroup(
                    members: <PlatformMenuItem>[
                      PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.toggleFullScreen),
                    ],
                  ),
                  PlatformMenuItemGroup(
                    members: <PlatformMenuItem>[
                      PlatformMenuItem(
                        label: 'Toggle Playlist',
                        shortcut: const SingleActivator(
                          LogicalKeyboardKey.keyP,
                          meta: true,
                        ),
                        onSelected: () {
                          _videoPlayerKey.currentState?.togglePlaylist();
                        },
                      ),
                    ],
                  ),
                ],
              ),
              PlatformMenu(
                label: 'Window',
                menus: const <PlatformMenuItem>[
                  PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.minimizeWindow),
                  PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.zoomWindow),
                  // Removed incompatible bringAllToFront
                ],
              ),
              const PlatformMenu(label: 'Help', menus: <PlatformMenuItem>[]),
            ],
            child: VideoPlayerScreen(key: _videoPlayerKey),
          ),
        ),
      ),
    );
  }
}

class TogglePlaylistIntent extends Intent {
  const TogglePlaylistIntent();
}

