import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:cross_file/cross_file.dart';
import 'package:path/path.dart' as path;
import '../config/app_config.dart';

class FileService {
  static bool isVideoFile(String filePath) {
    return AppConfig.supportedVideoExtensions
        .any((ext) => filePath.toLowerCase().endsWith(ext));
  }
  
  static Future<String?> pickVideoFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );
      
      if (result != null && result.files.isNotEmpty && result.files.single.path != null) {
        final videoPath = result.files.single.path!;
        return videoPath;
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }
  
  static String? getVideoFromDroppedFiles(List<XFile> files) {
    if (files.isEmpty) return null;
    
    final file = files.first;
    final videoPath = file.path;
    
    if (isVideoFile(videoPath)) {
      return videoPath;
    }
    
    return null;
  }
  
  static Future<bool> fileExists(String filePath) async {
    try {
      final file = File(filePath);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }
  
  static String getFileName(String filePath) {
    final file = File(filePath);
    return file.uri.pathSegments.last;
  }
  
  static String getFileNameWithoutExtension(String filePath) {
    return path.basenameWithoutExtension(filePath);
  }
  
  static Future<List<String>> loadVideoFilesFromFolder(String videoFilePath) async {
    try {
      final file = File(videoFilePath);
      final directory = file.parent;
      
      if (!await directory.exists()) {
        return [];
      }
      
      final List<FileSystemEntity> entities = await directory.list().toList();
      final List<String> videoFiles = [];
      
      for (final entity in entities) {
        if (entity is File && isVideoFile(entity.path)) {
          videoFiles.add(entity.path);
        }
      }
      
      // Sort by filename (case-insensitive)
      videoFiles.sort((a, b) => 
        getFileName(a).toLowerCase().compareTo(getFileName(b).toLowerCase()));
      
      return videoFiles;
    } catch (e) {
      return [];
    }
  }
  
  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    
    if (duration.inHours > 0) {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
  }
}
