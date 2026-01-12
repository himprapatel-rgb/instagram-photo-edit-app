import 'package:flutter/material.dart';

enum LayerType { image, text, sticker, shape, drawing }

@immutable
class Layer {
  final String id;
  final String name;
  final LayerType type;
  final Offset offset;
  final double rotation;
  final double scale;
  final bool isVisible;
  final double opacity;
  final BlendMode blendMode;
  final dynamic data;
  final Color? color;

  const Layer({
    required this.id,
    required this.name,
    required this.type,
    this.offset = Offset.zero,
    this.rotation = 0.0,
    this.scale = 1.0,
    this.isVisible = true,
    this.opacity = 1.0,
    this.blendMode = BlendMode.srcOver,
    this.data,
    this.color,
  });

  Layer copyWith({
    String? name,
    Offset? offset,
    double? rotation,
    double? scale,
    bool? isVisible,
    double? opacity,
    BlendMode? blendMode,
    dynamic data,
    Color? color,
  }) {
    return Layer(
      id: this.id,
      type: this.type,
      name: name ?? this.name,
      offset: offset ?? this.offset,
      rotation: rotation ?? this.rotation,
      scale: scale ?? this.scale,
      isVisible: isVisible ?? this.isVisible,
      opacity: opacity ?? this.opacity,
      blendMode: blendMode ?? this.blendMode,
      data: data ?? this.data,
      color: color ?? this.color,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Layer &&
        other.id == id &&
        other.name == name &&
        other.opacity == opacity &&
        other.isVisible == isVisible &&
        other.blendMode == blendMode;
  }

  @override
  int get hashCode => Object.hash(id, name, opacity, isVisible, blendMode);
}
