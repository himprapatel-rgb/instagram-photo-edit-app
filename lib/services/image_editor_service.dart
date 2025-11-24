import 'package:image/image.dart' as img;

class ImageEditorService {
  /// Apply brightness adjustment to image
  static img.Image adjustBrightness(img.Image image, double brightness) {
    final result = img.Image.from(image);
    for (int i = 0; i < result.length; i++) {
      final pixel = result[i];
      final a = img.getAlpha(pixel);
      final r = (img.getRed(pixel) * brightness).clamp(0, 255).toInt();
      final g = (img.getGreen(pixel) * brightness).clamp(0, 255).toInt();
      final b = (img.getBlue(pixel) * brightness).clamp(0, 255).toInt();
      result[i] = img.getColor(r, g, b, a);
    }
    return result;
  }

  /// Apply contrast adjustment to image
  static img.Image adjustContrast(img.Image image, double contrast) {
    final result = img.Image.from(image);
    for (int i = 0; i < result.length; i++) {
      final pixel = result[i];
      final a = img.getAlpha(pixel);
      final r = (((img.getRed(pixel) / 255 - 0.5) * contrast + 0.5) * 255).clamp(0, 255).toInt();
      final g = (((img.getGreen(pixel) / 255 - 0.5) * contrast + 0.5) * 255).clamp(0, 255).toInt();
      final b = (((img.getBlue(pixel) / 255 - 0.5) * contrast + 0.5) * 255).clamp(0, 255).toInt();
      result[i] = img.getColor(r, g, b, a);
    }
    return result;
  }

  /// Convert image to grayscale
  static img.Image grayscale(img.Image image) {
    return img.grayscale(image);
  }

  /// Apply sepia tone effect
  static img.Image sepia(img.Image image) {
    final result = img.Image.from(image);
    for (int i = 0; i < result.length; i++) {
      final pixel = result[i];
      final r = img.getRed(pixel);
      final g = img.getGreen(pixel);
      final b = img.getBlue(pixel);
      final a = img.getAlpha(pixel);
      
      final gray = (0.299 * r + 0.587 * g + 0.114 * b).toInt();
      final sepiaR = (gray * 1.0).clamp(0, 255).toInt();
      final sepiaG = (gray * 0.8).clamp(0, 255).toInt();
      final sepiaB = (gray * 0.6).clamp(0, 255).toInt();
      
      result[i] = img.getColor(sepiaR, sepiaG, sepiaB, a);
    }
    return result;
  }

  /// Adjust saturation of image
  static img.Image adjustSaturation(img.Image image, double saturation) {
    final result = img.Image.from(image);
    for (int i = 0; i < result.length; i++) {
      final pixel = result[i];
      final a = img.getAlpha(pixel);
      final r = img.getRed(pixel) / 255.0;
      final g = img.getGreen(pixel) / 255.0;
      final b = img.getBlue(pixel) / 255.0;
      
      final max = [r, g, b].reduce((a, b) => a > b ? a : b);
      final min = [r, g, b].reduce((a, b) => a < b ? a : b);
      final delta = max - min;
      
      final l = (max + min) / 2;
      final s = delta == 0 ? 0 : (l < 0.5 ? delta / (max + min) : delta / (2 - max - min));
      var h = 0.0;
      
      if (delta != 0) {
        if (max == r) h = (((g - b) / delta) + (g < b ? 6 : 0)) / 6;
        else if (max == g) h = (((b - r) / delta) + 2) / 6;
        else h = (((r - g) / delta) + 4) / 6;
      }
      
      final newS = (s * saturation).clamp(0, 1);
      
      final c = (1 - (2 * l - 1).abs()) * newS;
      final x = c * (1 - (((h * 6) % 2) - 1).abs());
      final m = l - c / 2;
      
      double newR, newG, newB;
      if (h < 1/6) {
        newR = c; newG = x; newB = 0;
      } else if (h < 2/6) {
        newR = x; newG = c; newB = 0;
      } else if (h < 3/6) {
        newR = 0; newG = c; newB = x;
      } else if (h < 4/6) {
        newR = 0; newG = x; newB = c;
      } else if (h < 5/6) {
        newR = x; newG = 0; newB = c;
      } else {
        newR = c; newG = 0; newB = x;
      }
      
      final rInt = ((newR + m) * 255).clamp(0, 255).toInt();
      final gInt = ((newG + m) * 255).clamp(0, 255).toInt();
      final bInt = ((newB + m) * 255).clamp(0, 255).toInt();
      
      result[i] = img.getColor(rInt, gInt, bInt, a);
    }
    return result;
  }
}
