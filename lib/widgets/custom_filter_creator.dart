import 'package:flutter/material.dart';
import 'dart:convert';

/// Custom Filter Data Model
class CustomFilter {
  final String id;
  final String name;
  final double brightness;
  final double contrast;
  final double saturation;
  final double exposure;
  final double warmth;
  final double shadows;
  final double highlights;
  final double vibrance;
  final Color? tintColor;
  final DateTime createdAt;

  CustomFilter({
    required this.id,
    required this.name,
    this.brightness = 1.0,
    this.contrast = 1.0,
    this.saturation = 1.0,
    this.exposure = 0.0,
    this.warmth = 0.0,
    this.shadows = 0.0,
    this.highlights = 0.0,
    this.vibrance = 0.0,
    this.tintColor,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'brightness': brightness,
    'contrast': contrast,
    'saturation': saturation,
    'exposure': exposure,
    'warmth': warmth,
    'shadows': shadows,
    'highlights': highlights,
    'vibrance': vibrance,
    'tintColor': tintColor?.value,
    'createdAt': createdAt.toIso8601String(),
  };

  factory CustomFilter.fromJson(Map<String, dynamic> json) => CustomFilter(
    id: json['id'],
    name: json['name'],
    brightness: json['brightness'] ?? 1.0,
    contrast: json['contrast'] ?? 1.0,
    saturation: json['saturation'] ?? 1.0,
    exposure: json['exposure'] ?? 0.0,
    warmth: json['warmth'] ?? 0.0,
    shadows: json['shadows'] ?? 0.0,
    highlights: json['highlights'] ?? 0.0,
    vibrance: json['vibrance'] ?? 0.0,
    tintColor: json['tintColor'] != null ? Color(json['tintColor']) : null,
    createdAt: DateTime.parse(json['createdAt']),
  );
}

/// Custom Filter Creator Panel
class CustomFilterCreator extends StatefulWidget {
  final Function(CustomFilter) onFilterCreated;
  final Function(CustomFilter) onFilterApplied;
  final List<CustomFilter> savedFilters;
  final VoidCallback? onReset;

  // Current adjustment values to capture
  final double currentBrightness;
  final double currentContrast;
  final double currentSaturation;
  final double currentExposure;
  final double currentWarmth;
  final double currentShadows;
  final double currentHighlights;

  const CustomFilterCreator({
    Key? key,
    required this.onFilterCreated,
    required this.onFilterApplied,
    this.savedFilters = const [],
    this.onReset,
    this.currentBrightness = 1.0,
    this.currentContrast = 1.0,
    this.currentSaturation = 1.0,
    this.currentExposure = 0.0,
    this.currentWarmth = 0.0,
    this.currentShadows = 0.0,
    this.currentHighlights = 0.0,
  }) : super(key: key);

  @override
  State<CustomFilterCreator> createState() => _CustomFilterCreatorState();
}

class _CustomFilterCreatorState extends State<CustomFilterCreator> {
  final TextEditingController _nameController = TextEditingController();
  bool _showSaveDialog = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Custom Filters',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: Colors.blue, size: 24),
                    onPressed: () => setState(() => _showSaveDialog = true),
                    tooltip: 'Save Current as Filter',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Current settings preview
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[700]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Settings',
                  style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    _buildSettingChip('Brightness', widget.currentBrightness, 1.0),
                    _buildSettingChip('Contrast', widget.currentContrast, 1.0),
                    _buildSettingChip('Saturation', widget.currentSaturation, 1.0),
                    _buildSettingChip('Exposure', widget.currentExposure, 0.0),
                    _buildSettingChip('Warmth', widget.currentWarmth, 0.0),
                  ],
                ),
              ],
            ),
          ),
          
          // Save dialog
          if (_showSaveDialog) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Save as Custom Filter',
                    style: TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Filter name...',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() => _showSaveDialog = false);
                          _nameController.clear();
                        },
                        child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _saveFilter,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          
          const SizedBox(height: 16),
          
          // Saved filters list
          const Text(
            'My Filters',
            style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          
          if (widget.savedFilters.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.filter_none, color: Colors.grey[700], size: 32),
                    const SizedBox(height: 8),
                    Text(
                      'No custom filters yet',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Adjust settings and tap + to save',
                      style: TextStyle(color: Colors.grey[700], fontSize: 10),
                    ),
                  ],
                ),
              ),
            )
          else
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.savedFilters.length,
                itemBuilder: (context, index) {
                  final filter = widget.savedFilters[index];
                  return _buildFilterCard(filter);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSettingChip(String label, double value, double defaultValue) {
    final isModified = (value - defaultValue).abs() > 0.01;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isModified ? Colors.blue.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isModified ? Colors.blue : Colors.grey[700]!,
        ),
      ),
      child: Text(
        '$label: ${value.toStringAsFixed(1)}',
        style: TextStyle(
          color: isModified ? Colors.blue : Colors.grey,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildFilterCard(CustomFilter filter) {
    return GestureDetector(
      onTap: () => widget.onFilterApplied(filter),
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[700]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getFilterPreviewColor(filter),
                    _getFilterPreviewColor(filter).withOpacity(0.5),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.auto_fix_high, color: Colors.white, size: 20),
            ),
            const SizedBox(height: 4),
            Text(
              filter.name,
              style: const TextStyle(color: Colors.white, fontSize: 10),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Color _getFilterPreviewColor(CustomFilter filter) {
    // Generate a preview color based on filter settings
    final hue = ((filter.warmth + 1) * 30 + (filter.saturation * 60)) % 360;
    return HSLColor.fromAHSL(1.0, hue, 0.6, 0.5).toColor();
  }

  void _saveFilter() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final filter = CustomFilter(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      brightness: widget.currentBrightness,
      contrast: widget.currentContrast,
      saturation: widget.currentSaturation,
      exposure: widget.currentExposure,
      warmth: widget.currentWarmth,
      shadows: widget.currentShadows,
      highlights: widget.currentHighlights,
    );

    widget.onFilterCreated(filter);
    _nameController.clear();
    setState(() => _showSaveDialog = false);
  }
}
