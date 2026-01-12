import 'package:flutter/material.dart';
import 'dart:math' as math;

const Color kAccentColor = Color(0xFF1DB9A0);

class StickerWidget extends StatefulWidget {
  final Widget child;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const StickerWidget({
    Key? key,
    required this.child,
    this.isSelected = false,
    required this.onTap,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<StickerWidget> createState() => _StickerWidgetState();
}

class _StickerWidgetState extends State<StickerWidget> {
  Offset _position = const Offset(100, 100);
  double _scale = 1.0;
  double _rotation = 0.0;
  Offset _prevPosition = Offset.zero;
  double _prevScale = 1.0;
  double _prevRotation = 0.0;
  Offset _initialFocalPoint = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onScaleStart: (details) {
          widget.onTap();
          _prevPosition = _position;
          _prevScale = _scale;
          _prevRotation = _rotation;
          _initialFocalPoint = details.focalPoint;
        },
        onScaleUpdate: (details) {
          setState(() {
            final delta = details.focalPoint - _initialFocalPoint;
            _position = _prevPosition + delta;
            _scale = _prevScale * details.scale;
            _rotation = _prevRotation + details.rotation;
          });
        },
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Transform(
              transform: Matrix4.identity()..scale(_scale)..rotateZ(_rotation),
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  border: widget.isSelected ? Border.all(color: Colors.white, width: 2) : null,
                ),
                child: widget.child,
              ),
            ),
            if (widget.isSelected)
              Positioned(
                right: -20,
                bottom: -20,
                child: GestureDetector(
                  onTap: widget.onDelete,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 14, color: Colors.red),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
