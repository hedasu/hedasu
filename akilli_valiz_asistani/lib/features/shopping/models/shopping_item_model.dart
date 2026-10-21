class ShoppingItemModel {
  final String id;
  final String title;
  final String? tripId;
  final String category;
  final bool isPurchased;
  final double? estimatedPrice;

  const ShoppingItemModel({
    required this.id,
    required this.title,
    this.tripId,
    this.category = 'Genel',
    this.isPurchased = false,
    this.estimatedPrice,
  });

  ShoppingItemModel copyWith({
    String? id,
    String? title,
    String? tripId,
    String? category,
    bool? isPurchased,
    double? estimatedPrice,
  }) {
    return ShoppingItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      tripId: tripId ?? this.tripId,
      category: category ?? this.category,
      isPurchased: isPurchased ?? this.isPurchased,
      estimatedPrice: estimatedPrice ?? this.estimatedPrice,
    );
  }

  factory ShoppingItemModel.fromJson(Map<String, dynamic> json) {
    return ShoppingItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      tripId: json['tripId'] as String?,
      category: json['category'] as String? ?? 'Genel',
      isPurchased: json['isPurchased'] as bool? ?? false,
      estimatedPrice: (json['estimatedPrice'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'tripId': tripId,
      'category': category,
      'isPurchased': isPurchased,
      'estimatedPrice': estimatedPrice,
    };
  }
}
