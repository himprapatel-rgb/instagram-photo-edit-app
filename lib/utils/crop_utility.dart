import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Utility class for image cropping and transformations
class CropUtility {
  /// Crop an image to specified rectangle
  static Future<ui.Image?> cropImage(
    ui.Image image, {
    required Rect cropRect,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    
    final srcRect = Rect.fromLTWH(
      cropRect.left,
      cropRect.top,
      cropRect.width,
      cropRect.height,
    );
    
    final dstRect = Rect.fromLTWH(
      0,
      0,
      cropRect.width,
      cropRect.height,
    );
    
    canvas.drawImageRect(image, srcRect, dstRect, Paint());
    
    final picture = recorder.endRecording();
    return await picture.toImage(
      cropRect.width.toInt(),
      cropRect.height.toInt(),
    );
  }

  /// Crop image to Instagram aspect ratio
  static Future<ui.Image?> cropToAspectRatio(
    ui.Image image,
    AspectRatioPreset preset,
  ) async {
    final size = _calculateCropSize(image.width, image.height, preset);
    final offset = _calculateCenterOffset(image.width, image.height, size);
    
    final cropRect = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      size.width,
      size.height,
    );
    
    return cropImage(image, cropRect: cropRect);
  }

  /// Calculate crop size for aspect ratio
  static Size _calculateCropSize(
    int imageWidth,
    int imageHeight,
    AspectRatioPreset preset,
  ) {
    final aspectRatio = preset.ratio;
    double width, height;
    
    if (imageWidth / imageHeight > aspectRatio) {
      // Image is wider than target aspect ratio
      height = imageHeight.toDouble();
      width = height * aspectRatio;
    } else {
      // Image is taller than target aspect ratio
      width = imageWidth.toDouble();
      height = width / aspectRatio;
    }
    
    return Size(width, height);
  }

  /// Calculate centered offset for crop
  static Offset _calculateCenterOffset(
    int imageWidth,
    int imageHeight,
    Size cropSize,
  ) {
    final dx = (imageWidth - cropSize.width) / 2;
    final dy = (imageHeight - cropSize.height) / 2;
    return Offset(dx, dy);
  }

  /// Rotate image by degrees (90, 180, 270)
  static Future<ui.Image?> rotateImage(
    ui.Image image,
    int degrees,
  ) async {
    if (degrees % 90 != 0) {
      throw ArgumentError('Degrees must be multiple of 90');
    }
    
    final normalizedDegrees = degrees % 360;
    if (normalizedDegrees == 0) return image;
    
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    
    final isVerticalFlip = normalizedDegrees == 90 || normalizedDegrees == 270;
    final width = isVerticalFlip ? image.height : image.width;
    final height = isVerticalFlip ? image.width : image.height;
    
    canvas.save();
    canvas.translate(width / 2, height / 2);
    canvas.rotate(normalizedDegrees * 3.14159 / 180);
    canvas.translate(-image.width / 2, -image.height / 2);
    canvas.drawImage(image, Offset.zero, Paint());
    canvas.restore();
    
    final picture = recorder.endRecording();
    return await picture.toImage(width, height);
  }

  /// Flip image horizontally
  static Future<ui.Image?> flipHorizontal(ui.Image image) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    
    canvas.save();
    canvas.translate(image.width.toDouble(), 0);
    canvas.scale(-1.0, 1.0);
    canvas.drawImage(image, Offset.zero, Paint());
    canvas.restore();
    
    final picture = recorder.endRecording();
    return await picture.toImage(image.width, image.height);
  }

  /// Flip image vertically
  static Future<ui.Image?> flipVertical(ui.Image image) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    
    canvas.save();
    canvas.translate(0, image.height.toDouble());
    canvas.scale(1.0, -1.0);
    canvas.drawImage(image, Offset.zero, Paint());
    canvas.restore();
    
    final picture = recorder.endRecording();
    return await picture.toImage(image.width, image.height);
  }
}

/// Instagram aspect ratio presets
enum AspectRatioPreset {
  square(1.0, '1:1'),
  portrait(0.8, '4:5'),
  landscape(1.91, '1.91:1'),
  story(0.5625, '9:16');

  const AspectRatioPreset(this.ratio, this.label);
  final double ratio;
  final String label;
}
