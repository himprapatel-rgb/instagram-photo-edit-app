import 'package:flutter/material.dart';

const Color kAccentColor = Color(0xFF1DB9A0);

class BeforeAfterWidget extends StatefulWidget {
  final String originalUrl;
  final String editedUrl;
  final double height;

  const BeforeAfterWidget({
    Key? key,
    required this.originalUrl,
    required this.editedUrl,
    this.height = 400,
  }) : super(key: key);

  @override
  State<BeforeAfterWidget> createState() => _BeforeAfterWidgetState();
}

class _BeforeAfterWidgetState extends State<BeforeAfterWidget> {
  double _splitValue = 0.5;

  void _updateSplit(DragUpdateDetails details, double width) {
    setState(() {
      _splitValue += details.delta.dx / width;
      _splitValue = _splitValue.clamp(0.0, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final sliderPos = width * _splitValue;

        return SizedBox(
          height: widget.height,
          child: Stack(
            children: [
              // EDITED IMAGE (Background / After)
              Positioned.fill(
                child: Image.network(
                  widget.editedUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (c, child, p) => p == null
                      ? child
                      : const Center(child: CircularProgressIndicator(color: kAccentColor)),
                ),
              ),
              // ORIGINAL IMAGE (Foreground / Before)
              Positioned.fill(
                child: ClipRect(
                  clipper: _RectClipper(width * _splitValue),
                  child: Image.network(
                    widget.originalUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // SLIDER HANDLE
              Positioned(
                left: sliderPos - 20,
                top: 0,
                bottom: 0,
                width: 40,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onHorizontalDragUpdate: (details) => _updateSplit(details, width),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(width: 2, color: Colors.white),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 4,
                              spreadRadius: 1,
                            )
                          ],
                        ),
                        child: const Icon(Icons.compare_arrows, size: 18, color: kAccentColor),
                      ),
                    ],
                  ),
                ),
              ),
              // LABELS
              Positioned(
                top: 10,
                left: 10,
                child: Opacity(
                  opacity: _splitValue > 0.1 ? 1.0 : 0.0,
                  child: _buildLabel("BEFORE"),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Opacity(
                  opacity: _splitValue < 0.9 ? 1.0 : 0.0,
                  child: _buildLabel("AFTER"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _RectClipper extends CustomClipper<Rect> {
  final double clipWidth;
  _RectClipper(this.clipWidth);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, clipWidth, size.height);
  }

  @override
  bool shouldReclip(covariant _RectClipper oldClipper) {
    return oldClipper.clipWidth != clipWidth;
  }
}
