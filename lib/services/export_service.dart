import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

/// Service for exporting edited images
class ExportService {
  /// Export image to device storage
  static Future<File?> exportToGallery(
    ui.Image image, {
    String? fileName,
    ImageFormat format = ImageFormat.png,
    int quality = 95,
  }) async {
    try {
      final bytes = await _imageToBytes(image, format, quality);
      if (bytes == null) return null;
      
      final directory = await _getExportDirectory();
      final name = fileName ?? _generateFileName(format);
      final file = File('${directory.path}/$name');
      
      await file.writeAsBytes(bytes);
      return file;
    } catch (e) {
      debugPrint('Error exporting image: $e');
      return null;
    }
  }

  /// Share image via system share dialog
  static Future<bool> shareImage(
    ui.Image image, {
    String? text,
    ImageFormat format = ImageFormat.png,
    int quality = 95,
  }) async {
    try {
      final bytes = await _imageToBytes(image, format, quality);
      if (bytes == null) return false;
      
      final tempDir = await getTemporaryDirectory();
      final name = _generateFileName(format);
      final file = File('${tempDir.path}/$name');
      await file.writeAsBytes(bytes);
      
      await Share.shareXFiles(
        [XFile(file.path)],
        text: text,
      );
      
      return true;
    } catch (e) {
      debugPrint('Error sharing image: $e');
      return false;
    }
  }

  /// Get image bytes in specified format
  static Future<Uint8List?> getImageBytes(
    ui.Image image, {
    ImageFormat format = ImageFormat.png,
    int quality = 95,
  }) async {
    return _imageToBytes(image, format, quality);
  }

  /// Convert ui.Image to bytes
  static Future<Uint8List?> _imageToBytes(
    ui.Image image,
    ImageFormat format,
    int quality,
  ) async {
    try {
      final byteData = await image.toByteData(
        format: format == ImageFormat.png
            ? ui.ImageByteFormat.png
            : ui.ImageByteFormat.rawRgba,
      );
      
      if (byteData == null) return null;
      return byteData.buffer.asUint8List();
    } catch (e) {
      debugPrint('Error converting image to bytes: $e');
      return null;
    }
  }

  /// Get export directory
  static Future<Directory> _getExportDirectory() async {
    if (Platform.isAndroid) {
      // On Android, use the Pictures directory
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        return await getApplicationDocumentsDirectory();
      }
      
      // Create Pictures/InstagramEditor subfolder
      final pictures = Directory('${directory.parent.parent.parent.parent.path}/Pictures/InstagramEditor');
      if (!await pictures.exists()) {
        await pictures.create(recursive: true);
      }
      return pictures;
    } else if (Platform.isIOS) {
      // On iOS, use the Documents directory
      return await getApplicationDocumentsDirectory();
    } else {
      // On other platforms, use Downloads
      return await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
    }
  }

  /// Generate unique filename
  static String _generateFileName(ImageFormat format) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = format == ImageFormat.png ? 'png' : 'jpg';
    return 'edited_photo_$timestamp.$extension';
  }

  /// Calculate file size from bytes
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  /// Get image dimensions string
  static String formatDimensions(ui.Image image) {
    return '${image.width} × ${image.height}';
  }
}

/// Image export formats
enum ImageFormat {
  png,
  jpeg,
}

/// Export result model
class ExportResult {
  final bool success;
  final String? filePath;
  final String? errorMessage;
  final int? fileSize;

  const ExportResult({
    required this.success,
    this.filePath,
    this.errorMessage,
    this.fileSize,
  });

  factory ExportResult.success({
    required String filePath,
    required int fileSize,
  }) {
    return ExportResult(
      success: true,
      filePath: filePath,
      fileSize: fileSize,
    );
  }

  factory ExportResult.failure(String errorMessage) {
    return ExportResult(
      success: false,
      errorMessage: errorMessage,
    );
  }
}
