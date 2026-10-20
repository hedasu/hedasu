/// Kullanıcı Değerlendirme ve Yorum Modeli (ReviewModel)
///
/// Tamamlanan kiralamaların ardından aracın performansına, konforuna,
/// teknik özelliklerinin doğruluğuna ve destek memnuniyetine dair verilen puan ve yorumları modeller.
class ReviewModel {
  const ReviewModel({
    required this.id,
    required this.vehicleId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.specsMatched = true,
    this.purposeMatched = true,
    this.supportSatisfied = true,
  });

  /// Yorumun benzersiz ID'si
  final String id;

  /// Değerlendirilen aracın ID'si
  final String vehicleId;

  /// Yorumu yazan kullanıcının adı
  final String userName;

  /// 1.0 ile 5.0 arasında verilen yıldız puanı
  final double rating;

  /// Kullanıcının deneyim açıklaması ve görüşü
  final String comment;

  /// Yorumun oluşturulduğu tarih
  final DateTime createdAt;

  /// Aracın belirtilen özelliklerle birebir örtüşme durumu
  final bool specsMatched;

  /// Aracın seçilen amaca uygunluk derecesi
  final bool purposeMatched;

  /// otoVia müşteri destek hizmetinden memnuniyet durumu
  final bool supportSatisfied;
}
