import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

class EnhancementValues {
  final double brightness;
  final double contrast;
  final double saturation;
  final double warmth;
  EnhancementValues({required this.brightness, required this.contrast, required this.saturation, required this.warmth});
}

class AutoEnhanceService {
  static Future<EnhancementValues> analyze(File imageFile) async {
    return await compute(_calculateEnhancements, imageFile);
  }

  static EnhancementValues _calculateEnhancements(File file) {
    final bytes = file.readAsBytesSync();
    final image = img.decodeImage(bytes);
    if (image == null) {
      return EnhancementValues(brightness: 0, contrast: 0, saturation: 0, warmth: 0);
    }

    int totalPixels = image.width * image.height;
    double sumLuminance = 0;
    int minLum = 255, maxLum = 0;

    for (final pixel in image) {
      final lum = (0.299 * pixel.r + 0.587 * pixel.g + 0.114 * pixel.b).round();
      sumLuminance += lum;
      if (lum < minLum) minLum = lum;
      if (lum > maxLum) maxLum = lum;
    }

    final double avgLuminance = sumLuminance / totalPixels;
    double brightnessCorrection = ((128 - avgLuminance) / 255.0).clamp(-0.5, 0.5);
    double dynamicRange = (maxLum - minLum).toDouble();
    double contrastCorrection = dynamicRange < 200 ? (255 - dynamicRange) / 255.0 * 0.5 : 0.0;
    double saturationCorrection = brightnessCorrection > 0.1 ? 0.2 : (contrastCorrection > 0.2 ? 0.1 : 0.0);

    return EnhancementValues(
      brightness: brightnessCorrection,
      contrast: contrastCorrection,
      saturation: saturationCorrection,
      warmth: 0.0,
    );
  }
}
