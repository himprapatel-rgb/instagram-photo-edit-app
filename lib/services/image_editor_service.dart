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

    /// Apply Instagram-style filters
  static img.Image applyFilter(img.Image image, String filterName) {
    switch (filterName.toLowerCase()) {
      case 'original':
        return img.Image.from(image);
      case 'clarendon':
        var result = adjustSaturation(image, 1.3);
        result = adjustContrast(result, 1.2);
        return adjustBrightness(result, 1.1);
      case 'gingham':
        var result = adjustBrightness(image, 1.05);
        return adjustSaturation(result, 0.8);
      case 'vintage':
        var result = sepia(image);
        return adjustContrast(result, 0.9);
      case 'lomo':
        var result = adjustContrast(image, 1.5);
        return adjustSaturation(result, 1.2);
      case 'sepia':
        return sepia(image);
      case 'cool':
        return _applyCoolTone(image);
      case 'inkwell':
        return grayscale(image);
      case 'walden':
        var result = adjustBrightness(image, 1.1);
        return adjustSaturation(result, 1.3);
      case 'warm':
        return _applyWarmTone(image);
      case 'toaster':
        var result = adjustContrast(image, 1.2);
        result = adjustBrightness(result, 1.1);
        return _applyWarmTone(result);
      case 'valencia':
        var result = adjustBrightness(image, 1.08);
        result = adjustContrast(result, 1.08);
        return _applyWarmTone(result);
      case 'vivid':
        return adjustSaturation(image, 1.5);
      case 'juno':
        var result = adjustSaturation(image, 1.4);
        return adjustContrast(result, 1.2);
      case 'lark':
        var result = adjustBrightness(image, 1.1);
        result = adjustContrast(result, 0.9);
        return adjustSaturation(result, 1.2);
      case 'fade':
        var result = adjustBrightness(image, 1.1);
        return adjustSaturation(result, 0.7);
      case 'amaro':
        var result = adjustBrightness(image, 1.1);
        result = adjustContrast(result, 0.9);
        return adjustSaturation(result, 0.85);
      case 'poprocket':
        var result = adjustSaturation(image, 1.2);
        return adjustContrast(result, 1.1);
      case 'noir':
        var result = grayscale(image);
        return adjustContrast(result, 1.3);
      case 'ashby':
        var result = grayscale(image);
        result = adjustContrast(result, 1.2);
        return _applyCoolTone(result);
      case 'hudson':
        var result = adjustBrightness(image, 1.2);
        result = adjustContrast(result, 0.9);
        return _applyCoolTone(result);
      case 'aden':
        var result = adjustBrightness(image, 1.2);
        result = adjustSaturation(result, 0.85);
        return _applyCoolTone(result);
      case 'brannan':
        var result = adjustContrast(image, 1.4);
        return sepia(result);
      case 'brooklyn':
        var result = adjustBrightness(image, 1.1);
        result = adjustContrast(result, 0.9);
        return _applyWarmTone(result);
      default:
        return img.Image.from(image);
    }
  }

  /// Apply cool blue tone
  static img.Image _applyCoolTone(img.Image image) {
    final result = img.Image.from(image);
    for (int i = 0; i < result.length; i++) {
      final pixel = result[i];
      final r = (img.getRed(pixel) * 0.9).clamp(0, 255).toInt();
      final g = img.getGreen(pixel);
      final b = (img.getBlue(pixel) * 1.1).clamp(0, 255).toInt();
      final a = img.getAlpha(pixel);
      result[i] = img.getColor(r, g, b, a);
    }
    return result;
  }

  /// Apply warm orange tone
  static img.Image _applyWarmTone(img.Image image) {
    final result = img.Image.from(image);
    for (int i = 0; i < result.length; i++) {
      final pixel = result[i];
      final r = (img.getRed(pixel) * 1.1).clamp(0, 255).toInt();
      final g = (img.getGreen(pixel) * 1.05).clamp(0, 255).toInt();
      final b = (img.getBlue(pixel) * 0.9).clamp(0, 255).toInt();
      final a = img.getAlpha(pixel);
      result[i] = img.getColor(r, g, b, a);
    }
    return result;
  }
}
}
