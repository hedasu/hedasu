import 'package:flutter/material.dart';

class DailyWeatherItem {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final int precipitationProbability;
  final String conditionDescription;
  final IconData icon;

  const DailyWeatherItem({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.precipitationProbability,
    required this.conditionDescription,
    required this.icon,
  });
}

class HourlyWeatherItem {
  final DateTime time;
  final double temperature;
  final int precipitationProbability;
  final IconData icon;

  const HourlyWeatherItem({
    required this.time,
    required this.temperature,
    required this.precipitationProbability,
    required this.icon,
  });
}
