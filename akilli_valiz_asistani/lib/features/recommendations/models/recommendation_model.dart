import 'package:flutter/material.dart';

class RecommendationItem {
  final String title;
  final String reason;
  final String category;
  final IconData icon;
  final bool isWeatherBased;

  const RecommendationItem({
    required this.title,
    required this.reason,
    required this.category,
    required this.icon,
    this.isWeatherBased = false,
  });
}
