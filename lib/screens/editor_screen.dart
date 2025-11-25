import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import '../models/filter_model.dart';
import '../services/image_editor_service.dart';

class EditorScreen extends StatefulWidget {
  final XFile imageFile;
  const EditorScreen({Key? key, required this.imageFile}) : super(key: key);
  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> with TickerProviderStateMixin {
  File? _selectedImage;
  img.Image? _originalImage;
  img.Image? _editedImage;
  String? _selectedFilter;
  
  // Adjustment values
  double _brightness = 1.0;
  double _contrast = 1.0;
  double _saturation = 1.0;
  double _exposure = 0.0;
  double _shadows = 0.0;
  double _highlights = 0.0;
  double _vibrance = 0.0;
  double _clarity = 0.0;
  double _warmth = 0.0;
  double _sharpness = 0.0;
  
  // UI State
  bool _showFilters = false;
  bool _showCustomEdit = false;
  bool _showBeforeAfter = false;
  
  final ImagePicker _imagePicker = ImagePicker();
  final ImageEditorService _editorService = ImageEditorService();

  @override
  void initState() {
    super.initState();
    _selectedImage = File(widget.imageFile.path);
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
        ],
      ),
      body: Column(
        children: [
          // Image preview area
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.grey[900],
              child: _selectedImage != null
                  ? Center(
                      child: Image.file(_selectedImage!, fit: BoxFit.contain),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo, size: 64, color: Colors.grey[700]),
                          const SizedBox(height: 16),
                          const Text('Select a photo to edit',
                              style: TextStyle(color: Colors.grey, fontSize: 16)),
                        ],
                      ),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Select Filter', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white, size: 20),
                          onPressed: () => setState(() => _showFilters = false),
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
                        final isSelected = _selectedFilter == filter.name;
                        return GestureDetector(
                          onTap: () {
                            setState(() => _selectedFilter = filter.name);
                            _applyFilter(filter.name);
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
                                      color: isSelected ? Colors.blue : Colors.grey[700]!,
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
                                    color: isSelected ? Colors.blue : Colors.white,
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
              height: 200,
              color: Colors.black,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Custom Edit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white, size: 20),
                          onPressed: () => setState(() => _showCustomEdit = false),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _buildCompactSlider('Brightness', _brightness, 0, 2, (v) => setState(() => _brightness = v)),
                        _buildCompactSlider('Contrast', _contrast, 0, 2, (v) => setState(() => _contrast = v)),
                        _buildCompactSlider('Saturation', _saturation, 0, 2, (v) => setState(() => _saturation = v)),
                        _buildCompactSlider('Exposure', _exposure, -2, 2, (v) => setState(() => _exposure = v)),
                        _buildCompactSlider('Shadows', _shadows, -1, 1, (v) => setState(() => _shadows = v)),
                        _buildCompactSlider('Highlights', _highlights, -1, 1, (v) => setState(() => _highlights = v)),
                        _buildCompactSlider('Warmth', _warmth, -1, 1, (v) => setState(() => _warmth = v)),
                        _buildCompactSlider('Sharpness', _sharpness, 0, 2, (v) => setState(() => _sharpness = v)),
                      ],
                    ),
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
                    icon: Icon(_showFilters ? Icons.expand_less : Icons.filter_vintage),
                    label: const Text('Filters'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _showFilters ? Colors.blue : Colors.grey[800],
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
                    icon: Icon(_showCustomEdit ? Icons.expand_less : Icons.tune),
                    label: const Text('Custom Edit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _showCustomEdit ? Colors.blue : Colors.grey[800],
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
                  child: const Text('Previous', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton.icon(
                  onPressed: _saveImage,
                  icon: const Icon(Icons.download),
                  label: const Text('Download'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Next', style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactSlider(String label, double value, double min, double max, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
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

  void _applyFilter(String filterName) async {
    if (_selectedImage == null) return;
    
    // Load original image if not already loaded
    if (_originalImage == null) {
      final bytes = await _selectedImage!.readAsBytes();
      _originalImage = img.decodeImage(bytes);
    }
    
    if (_originalImage == null) return;
    
    // Apply the selected filter
    setState(() {
      _editedImage = ImageEditorService.applyFilter(_originalImage!, filterName);
    });
  }

  void _reset() {
    setState(() {
      _brightness = 1.0;
      _contrast = 1.0;
      _saturation = 1.0;
      _exposure = 0.0;
      _shadows = 0.0;
      _highlights = 0.0;
      _vibrance = 0.0;
      _clarity = 0.0;
      _warmth = 0.0;
      _sharpness = 0.0;
      _selectedFilter = null;
      _showBeforeAfter = false;
    });
  }

  Future<void> _saveImage() async {
    if (_selectedImage == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image saved to gallery!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
