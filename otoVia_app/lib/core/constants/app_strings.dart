/// otoVia Uygulama Metin Sabitleri
///
/// Arayüz genelinde tekrar eden başlıklar, etiketler ve buton metinlerini
/// merkezi olarak tutarak tutarlılık sağlar ve yerelleştirmeyi (i18n) kolaylaştırır.
abstract final class AppStrings {
  // ==========================================
  // Uygulama & Karşılama Başlıkları
  // ==========================================
  /// Uygulama adı
  static const String appName = 'otoVia';
  /// Uygulama sloganı
  static const String appTagline = 'Lüks ve Minimalist Araç Kiralama';
  /// Keşif başlığı
  static const String discoverTitle = 'Aracını keşfet.';
  /// Keşif alt başlığı
  static const String discoverSubtitle = 'Saatlik ve günlük ayrıcalıklı kiralama seçenekleri';

  // ==========================================
  // Alt Navigasyon (Bottom Navigation) Başlıkları
  // ==========================================
  static const String navHome = 'Ana Sayfa';
  static const String navFavorites = 'Favoriler';
  static const String navReservations = 'Kiralamalar';
  static const String navNotifications = 'Bildirimler';
  static const String navProfile = 'Profil';

  // ==========================================
  // Kiralama Süre Türleri
  // ==========================================
  static const String hourlyRental = 'Saatlik Kiralama';
  static const String dailyRental = 'Günlük Kiralama';
  static const String hourly = 'Saatlik';
  static const String daily = 'Günlük';

  // ==========================================
  // Araç Kategorileri
  // ==========================================
  static const String catAll = 'Tümü';
  static const String catMotorcycle = 'Motosiklet';
  static const String catSedan = 'Binek';
  static const String catSuv = 'SUV';
  static const String catGroup = 'Geniş Grup';
  static const String catCommercial = 'Nakliye & Ticari';

  // ==========================================
  // Kullanım Amacına Göre Filtreler
  // ==========================================
  static const String purposeCity = 'Şehir İçi Ulaşım';
  static const String purposeFamily = 'Aile Seyahati';
  static const String purposeLongTrip = 'Uzun Yol';
  static const String purposeGroup = 'Grup Yolculuğu';
  static const String purposeCargo = 'Eşya Taşıma';

  // ==========================================
  // Eylem ve Buton Metinleri
  // ==========================================
  static const String inspectVehicle = 'Aracı İncele';
  static const String reserveNow = 'Rezerve Et';
  static const String compare = 'Karşılaştır';
  static const String addToFavorites = 'Favorilere Ekle';
  static const String removeFromFavorites = 'Favorilerden Çıkar';
  static const String undo = 'Geri Al';
  static const String applyCoupon = 'Kupon Uygula';
  static const String confirmReservation = 'Rezervasyonu Kesinleştir';
  static const String liveSupport = 'Canlı Destek';
  static const String extendDuration = 'Süre Uzat';
  static const String completeInspection = 'Teslimat Kaydı Tamamla';
  static const String rateAndReview = 'Değerlendir & Yorum Yap';
}
