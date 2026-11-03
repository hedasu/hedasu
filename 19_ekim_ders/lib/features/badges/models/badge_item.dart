// -bu dosyada başarı rozetlerinin kategorilerini belirten enum yapısı ve her bir rozetin verilerini taşıyan değişmez (immutable) BadgeItem veri modeli anlatılıyor.-
// enum (Numaralandırma) : Bir değişkenin alabileceği sabit ve sınırlı seçenekleri (Örn: su, egzersiz, genel) tip güvenli (type-safe) bir şekilde tanımlamayı sağlar; String yazım hatalarını önler.
// Immutable (Değişmez) Sınıf : Nesne bir kez oluşturulduktan sonra içindeki hiçbir alanın (`final` olduğu için) sonradan değiştirilemediği güvenli veri modelidir.

/// Rozet kategorileri
enum BadgeCategory { water, workout, general } // BadgeCategory : Rozetin hangi modüle ait olduğunu belirtir (water: Su, workout: Egzersiz, general: Genel/Birleşik).

/// Başarı rozeti veri modeli (Immutable).
class BadgeItem { // class BadgeItem : Ekranda gösterilecek tek bir rozetin tüm bilgilerini bir arada tutan kalıp (model) sınıfı.
  const BadgeItem({ // const kurucu : Tüm alanlar final olduğu için derleme zamanında sabit nesneler üretilmesine izin verir.
    required this.id, // required : Nesne oluşturulurken bu parametrenin verilmesi zorunludur | this.id : Gelen değeri doğrudan sınıfın id alanına atar.
    required this.title, // Rozetin ekranda görünecek ana başlığı (Örn: 'Hidrasyon Şampiyonu').
    required this.description, // Rozetin nasıl kazanılacağını anlatan açıklama metni.
    required this.iconEmoji, // Rozeti temsil eden görsel emoji karakteri (Örn: '💧', '🔥').
    required this.category, // Rozetin ait olduğu kategori (BadgeCategory enum tipinde).
    required this.isUnlocked, // Rozetin kilidinin açılıp açılmadığı bilgisi (true: Kazanıldı, false: Kilitli).
    this.progress = 0.0, // Varsayılan değerli parametre : Eğer dışarıdan verilmezse ilerleme oranı otomatik `0.0` kabul edilir.
    this.requirementText = '', // Varsayılan değerli parametre : Dışarıdan verilmezse gereksinim metni boş string `''` olur.
  });

  final String id; // final : Benzersiz rozet kimliği (bir kez atanır, değiştirilemez).
  final String title; // final : Rozet adı.
  final String description; // final : Rozet açıklaması.
  final String iconEmoji; // final : Rozet emojisi.
  final BadgeCategory category; // final : Rozet kategorisi.
  final bool isUnlocked; // final : Kilit açık mı? (true / false).
  final double progress; // final : İlerleme çubuğu (LinearProgressIndicator) için 0.0 ile 1.0 arasındaki oran.
  final String requirementText; // final : İlerleme çubuğunun yanında yazan durum metni (Örn: '1500 / 2500 ml').
}

// ÇALIŞMA MANTIĞI: BadgeController güncel verilerle BadgeItem nesnelerini üretir -> BadgeView bu nesneleri listeler -> BadgeCard her bir BadgeItem nesnesinin alanlarını (title, progress, isUnlocked vb.) okuyup ekrana çizer.

// ENUM KULLANIMI (`BadgeCategory.water`) : Derleyici tarafından kontrol edilir, yanlış yazılması imkansızdır ve IDE otomatik tamamlama sunar.
//  VS
// STRING KULLANIMI (`'water'`) : Harf hatası yapmaya (Örn: `'watre'` yazmaya) açıktır ve bu hata derleme sırasında değil, uygulama çalışırken (runtime) fark edilir.
