/// Antrenman Kaydı Modeli (Immutable)
class WorkoutEntryModel {
  final String id;
  final String title;
  final int durationMinutes;
  final int caloriesBurned;
  final DateTime timestamp;
  final String category;

  const WorkoutEntryModel({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.timestamp,
    required this.category,
  });

  WorkoutEntryModel copyWith({
    String? id,
    String? title,
    int? durationMinutes,
    int? caloriesBurned,
    DateTime? timestamp,
    String? category,
  }) {
    return WorkoutEntryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      timestamp: timestamp ?? this.timestamp,
      category: category ?? this.category,
    );
  }

  factory WorkoutEntryModel.fromJson(Map<String, dynamic> json) {
    return WorkoutEntryModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      durationMinutes: json['durationMinutes'] as int? ?? 0,
      caloriesBurned: json['caloriesBurned'] as int? ?? 0,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      category: json['category'] as String? ?? 'strength',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'durationMinutes': durationMinutes,
      'caloriesBurned': caloriesBurned,
      'timestamp': timestamp.toIso8601String(),
      'category': category,
    };
  }
}
