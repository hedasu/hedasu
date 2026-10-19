/// Su Tüketim Kaydı Modeli (Immutable)
class WaterEntryModel {
  final String id;
  final int amountMl;
  final DateTime timestamp;
  final String label;

  const WaterEntryModel({
    required this.id,
    required this.amountMl,
    required this.timestamp,
    required this.label,
  });

  WaterEntryModel copyWith({
    String? id,
    int? amountMl,
    DateTime? timestamp,
    String? label,
  }) {
    return WaterEntryModel(
      id: id ?? this.id,
      amountMl: amountMl ?? this.amountMl,
      timestamp: timestamp ?? this.timestamp,
      label: label ?? this.label,
    );
  }

  factory WaterEntryModel.fromJson(Map<String, dynamic> json) {
    return WaterEntryModel(
      id: json['id'] as String? ?? '',
      amountMl: json['amountMl'] as int? ?? 0,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      label: json['label'] as String? ?? 'Bardak Su',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amountMl': amountMl,
      'timestamp': timestamp.toIso8601String(),
      'label': label,
    };
  }
}
