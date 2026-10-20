class CouponModel {
  const CouponModel({
    required this.id,
    required this.code,
    required this.title,
    required this.discountPercent,
    required this.description,
    required this.expiryDate,
    this.isUsed = false,
    this.isExpired = false,
  });

  final String id;
  final String code;
  final String title;
  final int discountPercent;
  final String description;
  final DateTime expiryDate;
  final bool isUsed;
  final bool isExpired;

  bool get isValid => !isUsed && !isExpired && expiryDate.isAfter(DateTime.now());

  CouponModel copyWith({
    bool? isUsed,
    bool? isExpired,
  }) {
    return CouponModel(
      id: id,
      code: code,
      title: title,
      discountPercent: discountPercent,
      description: description,
      expiryDate: expiryDate,
      isUsed: isUsed ?? this.isUsed,
      isExpired: isExpired ?? this.isExpired,
    );
  }
}
