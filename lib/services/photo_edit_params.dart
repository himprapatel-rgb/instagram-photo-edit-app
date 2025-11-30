// lib/services/photo_edit_params.dart
import 'dart:ui';

class PhotoEditParams {
  final double brightness;   // -1.0 to +1.0
  final double contrast;     // 0.0 to 2.0
  final double saturation;   // 0.0 to 2.0
  final double temperature;  // -1.0 (cool) to +1.0 (warm)
  final double tint;         // -1.0 (green) to +1.0 (magenta)
  final double vignette;     // 0.0 to 1.0
  final String? selectedFilterId;

  // crop / rotate
  final Rect? cropRect;      // normalized 0–1 coordinates
  final double rotationDeg;  // -180 to +180
  final bool flipHorizontal;
  final bool flipVertical;

  const PhotoEditParams({
    this.brightness = 0.0,
    this.contrast = 1.0,
    this.saturation = 1.0,
    this.temperature = 0.0,
    this.tint = 0.0,
    this.vignette = 0.0,
    this.selectedFilterId,
    this.cropRect,
    this.rotationDeg = 0.0,
    this.flipHorizontal = false,
    this.flipVertical = false,
  });

  PhotoEditParams copyWith({
    double? brightness,
    double? contrast,
    double? saturation,
    double? temperature,
    double? tint,
    double? vignette,
    String? selectedFilterId,
    Rect? cropRect,
    double? rotationDeg,
    bool? flipHorizontal,
    bool? flipVertical,
  }) {
    return PhotoEditParams(
      brightness: brightness ?? this.brightness,
      contrast: contrast ?? this.contrast,
      saturation: saturation ?? this.saturation,
      temperature: temperature ?? this.temperature,
      tint: tint ?? this.tint,
      vignette: vignette ?? this.vignette,
      selectedFilterId: selectedFilterId ?? this.selectedFilterId,
      cropRect: cropRect ?? this.cropRect,
      rotationDeg: rotationDeg ?? this.rotationDeg,
      flipHorizontal: flipHorizontal ?? this.flipHorizontal,
      flipVertical: flipVertical ?? this.flipVertical,
    );
  }

  static PhotoEditParams get initial => const PhotoEditParams();
}
