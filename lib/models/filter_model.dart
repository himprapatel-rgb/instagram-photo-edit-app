import 'package:flutter/material.dart';

class FilterModel {
  final String name;
  final String description;
  final Color color;

  FilterModel({
    required this.name,
    required this.description,
    required this.color,
  });

  /// Premium Instagram-ready filters inspired by VSCO, Snapseed, Lightroom
  static final List<FilterModel> premiumFilters = [
    // Classic Filters
    FilterModel(
      name: 'Original',
      description: 'No filter applied',
      color: Color(0xFFFFFFFF),
    ),
    FilterModel(
      name: 'Clarendon',
      description: 'Enhanced vibrant colors',
      color: Color(0xFFF7DC6F),
    ),
    FilterModel(
      name: 'Gingham',
      description: 'Soft and pale',
      color: Color(0xFFF8BBD0),
    ),
    // Vintage Filters
    FilterModel(
      name: 'Vintage',
      description: 'Classic vintage effect',
      color: Color(0xFFD4A574),
    ),
    FilterModel(
      name: 'Lomo',
      description: 'High contrast and vignette',
      color: Color(0xFF8B4513),
    ),
    FilterModel(
      name: 'Sepia',
      description: 'Warm retro tone',
      color: Color(0xFF704010),
    ),
    // Cool Filters
    FilterModel(
      name: 'Cool',
      description: 'Blue tones and crisp',
      color: Color(0xFF4A90E2),
    ),
    FilterModel(
      name: 'Inkwell',
      description: 'Black and white classic',
      color: Color(0xFF2C3E50),
    ),
    FilterModel(
      name: 'Walden',
      description: 'Bright and crisp',
      color: Color(0xFF87CEEB),
    ),
    // Warm Filters
    FilterModel(
      name: 'Warm',
      description: 'Orange tones',
      color: Color(0xFFE8954A),
    ),
    FilterModel(
      name: 'Toaster',
      description: 'Warm and saturated',
      color: Color(0xFFF5DEB3),
    ),
    FilterModel(
      name: 'Valencia',
      description: 'Soft warm filter',
      color: Color(0xFFDAA520),
    ),
    // Bold & Vibrant
    FilterModel(
      name: 'Vivid',
      description: 'Highly saturated colors',
      color: Color(0xFFFF6B6B),
    ),
    FilterModel(
      name: 'Juno',
      description: 'Bold and saturated',
      color: Color(0xFFE91E63),
    ),
    FilterModel(
      name: 'Lark',
      description: 'Bright and natural',
      color: Color(0xFF3498DB),
    ),
    // Fade & Soft
    FilterModel(
      name: 'Fade',
      description: 'Faded and light',
      color: Color(0xFFE8E8E8),
    ),
    FilterModel(
      name: 'Amaro',
      description: 'Soft and slightly faded',
      color: Color(0xFFF0E68C),
    ),
    FilterModel(
      name: 'Poprocket',
      description: 'Slightly faded with warmth',
      color: Color(0xFFFFE4B5),
    ),
    // Dark & Moody
    FilterModel(
      name: 'Noir',
      description: 'Dark and moody',
      color: Color(0xFF1A1A1A),
    ),
    FilterModel(
      name: 'Ashby',
      description: 'Cool and dark',
      color: Color(0xFF2F4F4F),
    ),
    FilterModel(
      name: 'Hudson',
      description: 'Cool tone with vignette',
      color: Color(0xFF36454F),
    ),
    // Professional Filters
    FilterModel(
      name: 'Aden',
      description: 'Desaturated cool tones',
      color: Color(0xFF6B8E23),
    ),
    FilterModel(
      name: 'Brannan',
      description: 'High contrast with warm tones',
      color: Color(0xFFCD853F),
    ),
    FilterModel(
      name: 'Brooklyn',
      description: 'Warm and slightly desaturated',
      color: Color(0xFFB8860B),
    ),
  ];

  /// Predefined filters (legacy)
  static final List<FilterModel> predefinedFilters = premiumFilters;
}
