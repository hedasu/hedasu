class PackingItemModel {
  final String id;
  final String name;
  final String category;
  final int quantity;
  final double unitWeightKg;
  final double unitVolumeLiters;
  final bool isPacked;
  final bool isCustom;

  const PackingItemModel({
    required this.id,
    required this.name,
    required this.category,
    this.quantity = 1,
    this.unitWeightKg = 0.3,
    this.unitVolumeLiters = 1.0,
    this.isPacked = false,
    this.isCustom = false,
  });

  double get totalWeightKg => unitWeightKg * quantity;
  double get totalVolumeLiters => unitVolumeLiters * quantity;

  PackingItemModel copyWith({
    String? id,
    String? name,
    String? category,
    int? quantity,
    double? unitWeightKg,
    double? unitVolumeLiters,
    bool? isPacked,
    bool? isCustom,
  }) {
    return PackingItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      unitWeightKg: unitWeightKg ?? this.unitWeightKg,
      unitVolumeLiters: unitVolumeLiters ?? this.unitVolumeLiters,
      isPacked: isPacked ?? this.isPacked,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  factory PackingItemModel.fromJson(Map<String, dynamic> json) {
    return PackingItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      unitWeightKg: (json['unitWeightKg'] as num?)?.toDouble() ?? 0.3,
      unitVolumeLiters: (json['unitVolumeLiters'] as num?)?.toDouble() ?? 1.0,
      isPacked: json['isPacked'] as bool? ?? false,
      isCustom: json['isCustom'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'quantity': quantity,
      'unitWeightKg': unitWeightKg,
      'unitVolumeLiters': unitVolumeLiters,
      'isPacked': isPacked,
      'isCustom': isCustom,
    };
  }
}
