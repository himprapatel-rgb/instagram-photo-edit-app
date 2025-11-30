// lib/services/edit_engine.dart
import 'dart:typed_data';
import 'dart:math' as math;

import 'package:image/image.dart' as img;

import 'photo_edit_params.dart';

class EditEngine {
  const EditEngine();

  Future<Uint8List> applyEdits(
    Uint8List originalBytes,
    PhotoEditParams params,
  ) async {
    // Decode once
    img.Image? image = img.decodeImage(originalBytes);
    if (image == null) return originalBytes;

    // 1) crop + flip + rotate
    image = _applyCropAndGeometry(image, params);

    // 2) global adjustments (brightness, contrast, saturation, temp, tint, vignette)
    image = _applyGlobalAdjustments(image, params);

    // 3) TODO: filter matrix by selectedFilterId

    return Uint8List.fromList(img.encodeJpg(image, quality: 95));
  }

  img.Image _applyCropAndGeometry(img.Image src, PhotoEditParams params) {
    img.Image image = src;

    // Flip
    if (params.flipHorizontal) {
      image = img.flipHorizontal(image);
    }
    if (params.flipVertical) {
      image = img.flipVertical(image);
    }

    // Crop (normalized Rect)
    if (params.cropRect != null) {
      final r = params.cropRect!;
      final left = (r.left * image.width).round();
      final top = (r.top * image.height).round();
      final width = (r.width * image.width).round();
      final height = (r.height * image.height).round();

      image = img.copyCrop(
        image,
        x: left.clamp(0, image.width - 1),
        y: top.clamp(0, image.height - 1),
        width: width.clamp(1, image.width),
        height: height.clamp(1, image.height),
      );
    }

    // Rotate (nearest 90 or arbitrary)
    if (params.rotationDeg != 0.0) {
      image = img.copyRotate(image, angle: params.rotationDeg);
    }

    return image;
  }

  img.Image _applyGlobalAdjustments(img.Image src, PhotoEditParams params) {
    img.Image image = img.copyResize(src, width: src.width, height: src.height);

    final double brightness = params.brightness; // -1..+1
    final double contrast = params.contrast;     // 0..2
    final double saturation = params.saturation; // 0..2

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final c = image.getPixel(x, y);
        int r = img.getRed(c);
        int g = img.getGreen(c);
        int b = img.getBlue(c);
        final a = img.getAlpha(c);

        // Brightness
        r = (r + 255 * brightness).round();
        g = (g + 255 * brightness).round();
        b = (b + 255 * brightness).round();

        // Contrast
        r = (((r - 128) * contrast) + 128).round();
        g = (((g - 128) * contrast) + 128).round();
        b = (((b - 128) * contrast) + 128).round();

        // Simple saturation in HSL-ish space
        final avg = ((r + g + b) / 3).round();
        r = (avg + (r - avg) * saturation).round();
        g = (avg + (g - avg) * saturation).round();
        b = (avg + (b - avg) * saturation).round();

        // Clamp
        r = r.clamp(0, 255);
        g = g.clamp(0, 255);
        b = b.clamp(0, 255);

        image.setPixelRgba(x, y, r, g, b, a);
      }
    }

    // TODO: temperature, tint, vignette, filters

    return image;
  }
}
