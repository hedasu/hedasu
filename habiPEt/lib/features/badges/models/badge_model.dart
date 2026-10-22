import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

enum BadgeCategory {
  daily,
  weekly,
  monthly,
  yearly,
  special;

  String get displayName {
    switch (this) {
      case BadgeCategory.daily:
        return 'Günlük';
      case BadgeCategory.weekly:
        return 'Haftalık';
      case BadgeCategory.monthly:
        return 'Aylık';
      case BadgeCategory.yearly:
        return 'Yıllık';
      case BadgeCategory.special:
        return 'Özel Başarılar';
    }
  }

  // Hierarchy ranking: Yıllık > Aylık > Haftalık > Günlük
  int get hierarchyWeight {
    switch (this) {
      case BadgeCategory.yearly:
        return 5;
      case BadgeCategory.monthly:
        return 4;
      case BadgeCategory.weekly:
        return 3;
      case BadgeCategory.daily:
        return 2;
      case BadgeCategory.special:
        return 1;
    }
  }

  Color get categoryColor {
    switch (this) {
      case BadgeCategory.daily:
        return AppColors.badgeDaily;
      case BadgeCategory.weekly:
        return AppColors.badgeWeekly;
      case BadgeCategory.monthly:
        return AppColors.badgeMonthly;
      case BadgeCategory.yearly:
        return AppColors.badgeYearly;
      case BadgeCategory.special:
        return AppColors.badgeSpecial;
    }
  }
}

class BadgeModel {
  final String id;
  final String title;
  final String description;
  final BadgeCategory category;
  final int rewardCoins;
  final int targetDays;
  final int currentDays;
  final IconData icon;
  final bool isUnlocked;
  final DateTime? unlockedDate;

  const BadgeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.rewardCoins,
    required this.targetDays,
    required this.currentDays,
    required this.icon,
    required this.isUnlocked,
    this.unlockedDate,
  });

  double get progressRatio => (currentDays / targetDays).clamp(0.0, 1.0);
  String get progressText => '$currentDays/$targetDays';

  BadgeModel copyWith({
    String? id,
    String? title,
    String? description,
    BadgeCategory? category,
    int? rewardCoins,
    int? targetDays,
    int? currentDays,
    IconData? icon,
    bool? isUnlocked,
    DateTime? unlockedDate,
  }) {
    return BadgeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      rewardCoins: rewardCoins ?? this.rewardCoins,
      targetDays: targetDays ?? this.targetDays,
      currentDays: currentDays ?? this.currentDays,
      icon: icon ?? this.icon,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedDate: unlockedDate ?? this.unlockedDate,
    );
  }
}
