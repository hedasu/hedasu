/// Dünce uygulamasındaki tüm metin ve etiket sabitleri.
class AppStrings {
  AppStrings._();

  // Uygulama & Karşılama
  static const String appName = 'Dünce';
  static const String appTagline = 'Dün ve Düşünce’nin Buluştuğu Anı Günlüğü';
  static const String appLogoPath = 'assets/images/app_logo.jpg';
  static const String appMeaningTitle = 'Dünce Ne Demek?';
  static const String appMeaningDesc =
      'Geçmiş anlamına gelen "Dün" ve zihnin derinliklerindeki "Düşünce" kelimelerinin nostaljik birleşimi.\n'
      'Her anınız, zamanın sayfalarında solmayan bir hatıraya dönüşsün.';
  static const String startJournaling = 'Defteri Aç';

  // Navigasyon & Başlıklar
  static const String calendarTitle = 'Ajanda & Zaman Çizelgesi';
  static const String diaryTitle = 'Günün Sayfası';
  static const String stickersTitle = 'Dijital Çıkartmalar';
  static const String settingsTitle = 'Ayarlar & Görünüm';

  // Günlük Ekranı
  static const String emptyDiaryTitle = 'Bu Güne Henüz Bir Sayfa Açılmadı';
  static const String emptyDiarySubtitle =
      'Dünün anılarını veya bugünün düşüncelerini kaleme dökmek için dokun.';
  static const String newEntry = 'Yeni Anı Ekle';
  static const String editEntry = 'Anıyı Düzenle';
  static const String titleHint = 'Günün Başlığı...';
  static const String contentHint = 'Neler hissettin, aklından neler geçti? İster yaz, ister çiz...';
  static const String saveEntry = 'Deftere İşle';
  static const String deleteEntry = 'Sayfayı Kopar (Sil)';
  static const String deleteConfirmTitle = 'Anıyı Silmek İstiyor musunuz?';
  static const String deleteConfirmMessage = 'Bu işlem geri alınamaz. Sayfa sonsuza dek kaybolacak.';
  static const String cancel = 'Vazgeç';
  static const String delete = 'Sil';

  // Fotoğraf & Polaroid
  static const String addPhoto = 'Polaroid Ekle';
  static const String changePhoto = 'Fotoğrafı Değiştir';
  static const String removePhoto = 'Fotoğrafı Kaldır';
  static const String photoPermissionDenied = 'Galeri erişim izni verilmedi.';

  // Çizim & Kalem
  static const String drawingMode = 'El Yazısı / Çizim';
  static const String textMode = 'Klavye ile Yaz';
  static const String clearCanvas = 'Çizimi Temizle';
  static const String brushSize = 'Kalem Ucu';
  static const String brushColor = 'Mürekkep Rengi';

  // Duygu (Mood)
  static const String selectMood = 'Günün Duygu Mührü';
  static const String moodHappy = 'Huzurlu';
  static const String moodMelancholy = 'Melankolik';
  static const String moodThoughtful = 'Dalgın';
  static const String moodExcited = 'Coşkulu';
  static const String moodGrateful = 'Müteşekkir';
  static const String moodTired = 'Yorgun';

  // Çıkartmalar (Stickers)
  static const String stickerLibrary = 'Çıkartma Koleksiyonu';
  static const String selectSticker = 'Sayfaya Çıkartma Yapıştır';
  static const String tapToRemoveSticker = 'Kaldırmak için çıkartmaya çift dokunun';

  // Ayarlar & Tema
  static const String themeMode = 'Defter Teması';
  static const String lightTheme = 'Nostaljik Defter (Aydınlık)';
  static const String darkTheme = 'Antika Kitap (Koyu)';
  static const String toggleTheme = 'Temayı Değiştir';
}
