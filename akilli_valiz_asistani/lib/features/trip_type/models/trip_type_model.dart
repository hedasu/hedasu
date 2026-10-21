import 'package:flutter/material.dart';

class TripTypeOption {
  final String title;
  final String description;
  final IconData icon;
  final List<String> subTypes;
  final Color accentColor;

  const TripTypeOption({
    required this.title,
    required this.description,
    required this.icon,
    required this.subTypes,
    required this.accentColor,
  });
}
