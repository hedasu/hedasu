/// Rozet Modeli (Immutable)
class BadgeModel {
  final String id;
  final String title;
  final String description;
  final String iconName;
  final bool isUnlocked;
  final String category;
  final DateTime? unlockedAt;

  const BadgeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    this.isUnlocked = false,
    required this.category,
    this.unlockedAt,
  });

  BadgeModel copyWith({
    String? id,
    String? title,
    String? description,
    String? iconName,
    bool? isUnlocked,
    String? category,
    DateTime? unlockedAt,
  }) {
    return BadgeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      category: category ?? this.category,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      iconName: json['iconName'] as String? ?? 'military_tech',
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      category: json['category'] as String? ?? 'general',
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.tryParse(json['unlockedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconName': iconName,
      'isUnlocked': isUnlocked,
      'category': category,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }
}
