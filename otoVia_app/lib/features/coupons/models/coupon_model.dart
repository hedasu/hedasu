/// İndirim Kuponu ve Kampanya Modeli (CouponModel)
///
/// Kullanıcıya tanımlanan promosyon kodlarını, indirim oranını,
/// son geçerlilik tarihini ve kullanım/geçerlilik durumunu temsil eder.
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

  /// Benzersiz kupon kimliği
  final String id;

  /// Rezervasyon aşamasında girilecek promosyon kodu (ör. 'OTOVIA20', 'WELCOME10')
  final String code;

  /// Kampanya başlığı (ör. 'Hoş Geldin İndirimi')
  final String title;

  /// Yüzdelik indirim oranı (ör. 15, 20)
  final int discountPercent;

  /// Kampanya koşulları ve detay açıklaması
  final String description;

  /// Kuponun son kullanma tarihi
  final DateTime expiryDate;

  /// Kuponun daha önce kullanılıp kullanılmadığı
  final bool isUsed;

  /// Kuponun süresinin dolup dolmadığı
  final bool isExpired;

  /// Kuponun şu an aktif ve kullanılabilir olup olmadığını kontrol eder
  bool get isValid => !isUsed && !isExpired && expiryDate.isAfter(DateTime.now());

  /// Kupon durumunu güncellemek için kopya nesne üretir
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
