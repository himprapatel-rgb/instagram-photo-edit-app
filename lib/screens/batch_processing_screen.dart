import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

/// Batch Processing Screen
/// Process multiple images with the same filter/adjustments
class BatchProcessingScreen extends StatefulWidget {
  const BatchProcessingScreen({Key? key}) : super(key: key);

  @override
  State<BatchProcessingScreen> createState() => _BatchProcessingScreenState();
}

class _BatchProcessingScreenState extends State<BatchProcessingScreen> {
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _selectedImages = [];
  String? _selectedFilter;
  bool _isProcessing = false;
  double _processingProgress = 0.0;
  int _processedCount = 0;

  // Batch adjustment values
  double _brightness = 1.0;
  double _contrast = 1.0;
  double _saturation = 1.0;

  final List<String> _availableFilters = [
    'Original', 'A6 Analog', 'C1 Chrome', 'F2 Fuji', 'M5 Matte',
    'P5 Pastel', 'Portra 400', 'Kodak Gold', 'Tri-X 400', 'Velvia 50',
    'Ektar 100', 'Cinestill', 'Golden Hour', 'Nordic', 'Tokyo',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Batch Processing'),
        centerTitle: true,
        actions: [
          if (_selectedImages.isNotEmpty && !_isProcessing)
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: _startBatchProcessing,
              tooltip: 'Start Processing',
            ),
        ],
      ),
      body: Column(
        children: [
          // Image selection area
          Expanded(
            flex: 2,
            child: _buildImageGrid(),
          ),
          
          // Filter/adjustment selection
          Container(
            color: Colors.grey[900],
            child: Column(
              children: [
                // Filter selection
                Container(
                  height: 100,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Select Filter',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: _availableFilters.length,
                          itemBuilder: (context, index) {
                            final filter = _availableFilters[index];
                            final isSelected = _selectedFilter == filter;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedFilter = filter),
                              child: Container(
                                width: 60,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.blue : Colors.grey[800],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected ? Colors.blue : Colors.grey[700]!,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    filter,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.grey,
                                      fontSize: 9,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Quick adjustments
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildSlider('Brightness', _brightness, 0, 2, (v) => setState(() => _brightness = v)),
                      _buildSlider('Contrast', _contrast, 0, 2, (v) => setState(() => _contrast = v)),
                      _buildSlider('Saturation', _saturation, 0, 2, (v) => setState(() => _saturation = v)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Processing progress
          if (_isProcessing)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue.withOpacity(0.1),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Processing... $_processedCount/${_selectedImages.length}',
                        style: const TextStyle(color: Colors.blue),
                      ),
                      Text(
                        '${(_processingProgress * 100).toInt()}%',
                        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: _processingProgress,
                    backgroundColor: Colors.grey[800],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ],
              ),
            ),
          
          // Action buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isProcessing ? null : _pickImages,
                    icon: const Icon(Icons.add_photo_alternate),
                    label: Text(_selectedImages.isEmpty ? 'Select Images' : 'Add More'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: (_selectedImages.isEmpty || _isProcessing) ? null : _startBatchProcessing,
                    icon: Icon(_isProcessing ? Icons.hourglass_top : Icons.auto_fix_high),
                    label: Text(_isProcessing ? 'Processing...' : 'Process All'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGrid() {
    if (_selectedImages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_library_outlined, size: 64, color: Colors.grey[700]),
            const SizedBox(height: 16),
            Text(
              'No images selected',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap "Select Images" to add photos for batch processing',
              style: TextStyle(color: Colors.grey[700], fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _selectedImages.length,
      itemBuilder: (context, index) {
        return Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(_selectedImages[index].path),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => _removeImage(index),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 16),
                ),
              ),
            ),
            Positioned(
              bottom: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSlider(String label, double value, double min, double max, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
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
                onChanged: _isProcessing ? null : onChanged,
                activeColor: Colors.blue,
                inactiveColor: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(
            width: 35,
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

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _startBatchProcessing() async {
    if (_selectedImages.isEmpty) return;

    setState(() {
      _isProcessing = true;
      _processingProgress = 0.0;
      _processedCount = 0;
    });

    for (int i = 0; i < _selectedImages.length; i++) {
      // Simulate processing delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // TODO: Apply actual filter and adjustments to each image
      // final processedImage = await _processImage(_selectedImages[i]);
      
      setState(() {
        _processedCount = i + 1;
        _processingProgress = (i + 1) / _selectedImages.length;
      });
    }

    setState(() {
      _isProcessing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully processed ${_selectedImages.length} images!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
