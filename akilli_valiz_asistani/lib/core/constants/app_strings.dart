class AppStrings {
  AppStrings._();

  static const String appName = 'PackPilot';
  static const String appTagline = 'Akıllı Seyahat ve Valiz Asistanı';

  // Navigation & Headers
  static const String navHome = 'Ana Ekran';
  static const String navTrips = 'Ajandam';
  static const String navShopping = 'Alışveriş';
  static const String navProfile = 'Profil';

  // Trip Creation Flow
  static const String newTripTitle = 'Yeni Seyahat Planla';
  static const String selectDates = 'Tarih Aralığı Seçin';
  static const String selectLocation = 'Gidilecek Lokasyon';
  static const String searchLocationHint = 'Şehir veya ülke ara (Örn: Paris, Tokyo, Antalya)...';
  static const String timePromptTitle = 'Varış ve Ayrılış Saatleri';
  static const String timePromptQuestion =
      'Size daha doğru öneriler sunabilmemiz için varış ve ayrılış saatlerinizi girmek ister misiniz?';
  static const String btnYesTime = 'Evet, Saat Belirt';
  static const String btnSkipTime = 'Hayır, Devam Et';

  // Trip Types
  static const String tripTypeTitle = 'Seyahat Türü';
  static const String tripTypeSubtitle = 'Kıyafet ve ekipman önerilerini özelleştirmek için tür seçin';

  // Recommendations
  static const String recommendationsTitle = 'Akıllı Hazırlık Önerileri';
  static const String recommendationsSubtitle =
      'Lokasyon hava tahminine ve seyahat amacınıza özel öneriler';

  // Packing List
  static const String packingListTitle = 'Valiz Eşya Listesi';
  static const String packingListSubtitle = 'Kategorilere göre eşyalarınızı düzenleyin';
  static const String btnConfirmList = 'Listeyi Onayla';
  static const String btnAddItem = 'Eşya Ekle';

  // Luggage Analysis
  static const String analysisTitle = 'Valiz Ağırlık ve Hacim Analizi';
  static const String estimatedWeight = 'Tahmini Toplam Ağırlık';
  static const String estimatedVolume = 'Tahmini Toplam Hacim';
  static const String cabinWarning = 'Kabin Bagajı Sınır Uyarısı';
  static const String proceedToChecklist = 'Valiz Kontrolüne Geç';

  // Checklist
  static const String checklistTitle = 'Valiz Hazırlık Kontrolü';
  static const String toPackSection = 'Hazırlanacak Eşyalar';
  static const String packedSection = 'Alınanlar (Valizde)';
  static const String btnAddActivity = 'Ekle Aktivite';
  static const String btnFinish = 'Bitti';

  // Home Screen
  static const String currentLuggage = 'Güncel Valizim';
  static const String noActiveTrip = 'Henüz aktif bir seyahatiniz bulunmuyor.';
  static const String startFirstTrip = 'Yeni Seyahat Oluştur';
  static const String editTrip = 'Seyahati Düzenle';
  static const String deleteTrip = 'Aktiviteyi Sil';
}
