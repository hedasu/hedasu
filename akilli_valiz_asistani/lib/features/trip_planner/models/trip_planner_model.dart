import '../../packing_list/models/packing_item_model.dart';

class TripPlannerModel {
  final String id;
  final String destination;
  final double latitude;
  final double longitude;
  final DateTime startDate;
  final DateTime endDate;
  final int? arrivalHour;
  final int? arrivalMinute;
  final int? departureHour;
  final int? departureMinute;
  final String tripType;
  final String? tripSubType;
  final List<PackingItemModel> items;
  final bool isCompleted;
  final DateTime createdAt;

  const TripPlannerModel({
    required this.id,
    required this.destination,
    this.latitude = 41.0082,
    this.longitude = 28.9784,
    required this.startDate,
    required this.endDate,
    this.arrivalHour,
    this.arrivalMinute,
    this.departureHour,
    this.departureMinute,
    this.tripType = 'Tatil',
    this.tripSubType,
    this.items = const [],
    this.isCompleted = false,
    required this.createdAt,
  });

  bool get hasSpecificHours => arrivalHour != null || departureHour != null;

  int get durationDays {
    final s = DateTime(startDate.year, startDate.month, startDate.day);
    final e = DateTime(endDate.year, endDate.month, endDate.day);
    return e.difference(s).inDays + 1;
  }

  int get packedCount => items.where((it) => it.isPacked).length;
  int get totalItemsCount => items.length;
  double get packedRatio => items.isEmpty ? 0.0 : packedCount / items.length;

  double get totalWeightKg =>
      items.fold(0.0, (acc, item) => acc + item.totalWeightKg);

  double get totalVolumeLiters =>
      items.fold(0.0, (acc, item) => acc + item.totalVolumeLiters);

  TripPlannerModel copyWith({
    String? id,
    String? destination,
    double? latitude,
    double? longitude,
    DateTime? startDate,
    DateTime? endDate,
    int? arrivalHour,
    int? arrivalMinute,
    int? departureHour,
    int? departureMinute,
    String? tripType,
    String? tripSubType,
    List<PackingItemModel>? items,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return TripPlannerModel(
      id: id ?? this.id,
      destination: destination ?? this.destination,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      arrivalHour: arrivalHour ?? this.arrivalHour,
      arrivalMinute: arrivalMinute ?? this.arrivalMinute,
      departureHour: departureHour ?? this.departureHour,
      departureMinute: departureMinute ?? this.departureMinute,
      tripType: tripType ?? this.tripType,
      tripSubType: tripSubType ?? this.tripSubType,
      items: items ?? this.items,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory TripPlannerModel.fromJson(Map<String, dynamic> json) {
    return TripPlannerModel(
      id: json['id'] as String,
      destination: json['destination'] as String,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 41.0082,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 28.9784,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      arrivalHour: json['arrivalHour'] as int?,
      arrivalMinute: json['arrivalMinute'] as int?,
      departureHour: json['departureHour'] as int?,
      departureMinute: json['departureMinute'] as int?,
      tripType: json['tripType'] as String? ?? 'Tatil',
      tripSubType: json['tripSubType'] as String?,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => PackingItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'destination': destination,
      'latitude': latitude,
      'longitude': longitude,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'arrivalHour': arrivalHour,
      'arrivalMinute': arrivalMinute,
      'departureHour': departureHour,
      'departureMinute': departureMinute,
      'tripType': tripType,
      'tripSubType': tripSubType,
      'items': items.map((e) => e.toJson()).toList(),
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
