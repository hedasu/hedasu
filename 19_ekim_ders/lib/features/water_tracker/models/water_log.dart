/// Su tüketim kaydını temsil eden değişmez (immutable) veri modeli.
class WaterLog {
  const WaterLog({
    required this.id,
    required this.amountMl,
    required this.timestamp,
    required this.label,
  });

  final String id;
  final int amountMl;
  final DateTime timestamp;
  final String label;

  /// Saat ve dakika biçimlendirmesi (HH:mm)
  String get formattedTime {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
