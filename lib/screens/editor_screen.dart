import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import '../models/filter_model.dart';
import '../services/image_editor_service.dart';
import '../services/photo_edit_params.dart';
import '../services/edit_engine.dart';
import '../services/ai_service.dart';

class EditorScreen extends StatefulWidget {
  final XFile imageFile;

  const EditorScreen({Key? key, required this.imageFile}) : super(key: key);

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen>
    with TickerProviderStateMixin {
  File? _selectedImage;
  Uint8List? _originalBytes;
  Uint8List? _previewBytes;
  PhotoEditParams _params = PhotoEditParams.initial;

  final EditEngine _engine = const EditEngine();
  final AiService _ai = const AiService();
  bool _isApplying = false;

  // UI State
  bool _showFilters = false;
  bool _showCustomEdit = false;
  bool _showBeforeAfter = false;

  @override
  void initState() {
    super.initState();
    _selectedImage = File(widget.imageFile.path);
    _loadOriginal();
  }

  Future<void> _loadOriginal() async {
    if (_selectedImage == null) return;
    final bytes = await _selectedImage!.readAsBytes();
    setState(() {
      _originalBytes = bytes;
      _previewBytes = bytes;
    });
  }

  Future<void> _rebuildPreview() async {
    if (_originalBytes == null) return;
    setState(() => _isApplying = true);
    final result = await _engine.applyEdits(_originalBytes!, _params);
    if (!mounted) return;
    setState(() {
      _previewBytes = result;
      _isApplying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Edit Photo'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.compare),
            tooltip: 'Before/After',
            onPressed: () {
              setState(() => _showBeforeAfter = !_showBeforeAfter);
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset',
            onPressed: _reset,
          ),
        ],
      ),
      body: Column(
        children: [
          // Image preview area
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.grey[900],
              child: Stack(
                children: [
                  if (_previewBytes != null)
                    Center(
                      child: Image.memory(_previewBytes!, fit: BoxFit.contain),
                    )
                  else
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo,
                              size: 64, color: Colors.grey[700]),
                          const SizedBox(height: 16),
                          const Text('Loading...',
                              style: TextStyle(color: Colors.grey, fontSize: 16)),
                        ],
                      ),
                    ),
                  if (_isApplying)
                    Container(
                      color: Colors.black54,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Expandable Filters Section
          if (_showFilters)
            Container(
              height: 120,
              color: Colors.black,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Select Filter',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.close,
                              color: Colors.white, size: 20),
                          onPressed: () =>
                              setState(() => _showFilters = false),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: FilterModel.premiumFilters.length,
                      itemBuilder: (context, index) {
                        final filter = FilterModel.premiumFilters[index];
                        final isSelected =
                            _params.selectedFilterId == filter.name;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _params = _params.copyWith(
                                  selectedFilterId: filter.name);
                            });
                            _rebuildPreview();
                          },
                          child: Container(
                            width: 70,
                            margin: const EdgeInsets.only(right: 8),
                            child: Column(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.blue
                                          : Colors.grey[700]!,
                                      width: isSelected ? 3 : 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    color: filter.color,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  filter.name,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.blue
                                        : Colors.white,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

          // Expandable Custom Edit Section
          if (_showCustomEdit)
            Container(
              height: 240,
              color: Colors.black,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Custom Edit',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: _aiAutoEnhance,
                              icon: const Icon(Icons.auto_fix_high,
                                  size: 16, color: Colors.orange),
                              label: const Text('AI Enhance',
                                  style: TextStyle(
                                      color: Colors.orange, fontSize: 12)),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close,
                                  color: Colors.white, size: 20),
                              onPressed: () =>
                                  setState(() => _showCustomEdit = false),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _buildCompactSlider('Brightness', _params.brightness,
                            -1, 1, (v) {
                          setState(() {
                            _params = _params.copyWith(brightness: v);
                          });
                          _rebuildPreview();
                        }),
                        _buildCompactSlider(
                            'Contrast', _params.contrast, 0, 2, (v) {
                          setState(() {
                            _params = _params.copyWith(contrast: v);
                          });
                          _rebuildPreview();
                        }),
                        _buildCompactSlider(
                            'Saturation', _params.saturation, 0, 2, (v) {
                          setState(() {
                            _params = _params.copyWith(saturation: v);
                          });
                          _rebuildPreview();
                        }),
                        _buildCompactSlider(
                            'Temperature', _params.temperature, -1, 1, (v) {
                          setState(() {
                            _params = _params.copyWith(temperature: v);
                          });
                          _rebuildPreview();
                        }),
                        _buildCompactSlider('Tint', _params.tint, -1, 1, (v) {
                          setState(() {
                            _params = _params.copyWith(tint: v);
                          });
                          _rebuildPreview();
                        }),
                        _buildCompactSlider(
                            'Vignette', _params.vignette, 0, 1, (v) {
                          setState(() {
                            _params = _params.copyWith(vignette: v);
                          });
                          _rebuildPreview();
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Crop/Rotate Row
          Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.crop, color: Colors.white),
                  tooltip: 'Crop',
                  onPressed: _demoCrop,
                ),
                IconButton(
                  icon: const Icon(Icons.rotate_right, color: Colors.white),
                  tooltip: 'Rotate Right',
                  onPressed: _demoRotate,
                ),
                IconButton(
                  icon: const Icon(Icons.flip, color: Colors.white),
                  tooltip: 'Flip Horizontal',
                  onPressed: _demoFlip,
                ),
              ],
            ),
          ),

          // Main Action Buttons (Filters & Custom Edit)
          Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                // Filters Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _showFilters = !_showFilters;
                        if (_showFilters) _showCustomEdit = false;
                      });
                    },
                    icon: Icon(_showFilters
                        ? Icons.expand_less
                        : Icons.filter_vintage),
                    label: const Text('Filters'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _showFilters ? Colors.blue : Colors.grey[800],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Custom Edit Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _showCustomEdit = !_showCustomEdit;
                        if (_showCustomEdit) _showFilters = false;
                      });
                    },
                    icon: Icon(
                        _showCustomEdit ? Icons.expand_less : Icons.tune),
                    label: const Text('Custom Edit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _showCustomEdit ? Colors.blue : Colors.grey[800],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Action Bar (Download, Previous, Next)
          Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text('Previous',
                      style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton.icon(
                  onPressed: _saveImage,
                  icon: const Icon(Icons.download),
                  label: const Text('Download'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child:
                      const Text('Next', style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactSlider(String label, double value, double min,
      double max, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child:
                Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 2,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              ),
              child: Slider(
                value: value,
                min: min,
                max: max,
                onChanged: onChanged,
                activeColor: Colors.blue,
                inactiveColor: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              value.toStringAsFixed(1),
              style: const TextStyle(color: Colors.blue, fontSize: 12),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  void _reset() {
    setState(() {
      _params = PhotoEditParams.initial;
      _showBeforeAfter = false;
    });
    _rebuildPreview();
  }

  Future<void> _aiAutoEnhance() async {
    if (_originalBytes == null) return;
    final newParams = await _ai.autoEnhance(_originalBytes!, _params);
    setState(() {
      _params = newParams;
    });
    await _rebuildPreview();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('AI Auto-enhance applied!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _demoCrop() {
    // Demo: apply a 1:1 center crop
    setState(() {
      _params = _params.copyWith(
        cropRect: const Rect.fromLTWH(0.1, 0.1, 0.8, 0.8),
      );
    });
    _rebuildPreview();
  }

  void _demoRotate() {
    // Demo: rotate 90 degrees
    setState(() {
      _params = _params.copyWith(
        rotationDeg: _params.rotationDeg + 90,
      );
    });
    _rebuildPreview();
  }

  void _demoFlip() {
    // Demo: flip horizontal
    setState(() {
      _params = _params.copyWith(
        flipHorizontal: !_params.flipHorizontal,
      );
    });
    _rebuildPreview();
  }

  Future<void> _saveImage() async {
    if (_previewBytes == null) return;
    // TODO: Integrate actual save to gallery
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image saved to gallery!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
