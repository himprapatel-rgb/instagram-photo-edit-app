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

  static final List<FilterModel> predefinedFilters = [
    FilterModel(
      name: 'Vintage',
      description: 'A classic vintage effect',
      color: Color(0xFFD4A574),
    ),
    FilterModel(
      name: 'Cool',
      description: 'Cool blue tones',
      color: Color(0xFF4A90E2),
    ),
    FilterModel(
      name: 'Warm',
      description: 'Warm orange tones',
      color: Color(0xFFE8954A),
    ),
    FilterModel(
      name: 'Grayscale',
      description: 'Black and white',
      color: Color(0xFF808080),
    ),
    FilterModel(
      name: 'Sepia',
      description: 'Sepia tone effect',
      color: Color(0xFF704010),
    ),
    FilterModel(
      name: 'Vivid',
      description: 'Highly saturated colors',
      color: Color(0xFFFF6B6B),
    ),
    FilterModel(
      name: 'Fade',
      description: 'Faded, light effect',
      color: Color(0xFFE8E8E8),
    ),
    FilterModel(
      name: 'Noir',
      description: 'Dark and moody',
      color: Color(0xFF1A1A1A),
    ),
  ];
}
