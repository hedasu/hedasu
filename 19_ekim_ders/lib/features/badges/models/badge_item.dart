/// Rozet kategorileri
enum BadgeCategory { water, workout, general }

/// Başarı rozeti veri modeli (Immutable).
class BadgeItem {
  const BadgeItem({
    required this.id,
    required this.title,
    required this.description,
    required this.iconEmoji,
    required this.category,
    required this.isUnlocked,
    this.progress = 0.0,
    this.requirementText = '',
  });

  final String id;
  final String title;
  final String description;
  final String iconEmoji;
  final BadgeCategory category;
  final bool isUnlocked;
  final double progress;
  final String requirementText;
}
