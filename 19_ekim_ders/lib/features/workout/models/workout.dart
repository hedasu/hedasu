/// Egzersiz aktivitesini temsil eden değişmez (immutable) model.
class Workout {
  const Workout({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.category,
    required this.timestamp,
  });

  final String id;
  final String title;
  final int durationMinutes;
  final int caloriesBurned;
  final String category;
  final DateTime timestamp;

  /// Saat ve dakika biçimlendirmesi (HH:mm)
  String get formattedTime {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
