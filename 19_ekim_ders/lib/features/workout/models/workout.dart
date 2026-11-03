// -bu dosyada tamamlanan bir egzersiz aktivitesinin verilerini (başlık, süre, kalori, kategori, zaman) taşıyan değişmez (immutable) Workout veri modeli anlatılıyor.-
// const Constructor (Sabit Kurucu) : Sınıfın tüm değişkenleri `final` olduğunda, nesnelerin değiştirilemez (immutable) olarak güvenli bir şekilde üretilmesini sağlar.
// String Interpolation (`'$hour:$minute'`) : Değişken değerlerini `$` işareti kullanarak doğrudan metin (String) şablonunun içine yerleştirme yöntemidir.

/// Egzersiz aktivitesini temsil eden değişmez (immutable) model.
class Workout { // class Workout : Tek bir antrenman kaydının tüm özelliklerini temsil eden veri sınıfı.
  const Workout({
    required this.id, // Kaydı silerken kullanılan benzersiz kimlik (String).
    required this.title, // Egzersiz adı (Örn: 'Koşu', 'HIIT').
    required this.durationMinutes, // Egzersizin dakika cinsinden süresi (Örn: 25).
    required this.caloriesBurned, // Egzersizde yakılan kalori miktarı (Örn: 220).
    required this.category, // Egzersizin kategorisi.
    required this.timestamp, // Egzersizin kaydedildiği tarih ve saat (DateTime).
  });

  final String id; // final : Benzersiz ID (değiştirilemez).
  final String title; // final : Antrenman başlığı.
  final int durationMinutes; // final : Süre (dakika).
  final int caloriesBurned; // final : Yakılan kalori (kcal).
  final String category; // final : Kategori adı.
  final DateTime timestamp; // final : Kayıt zamanı.

  /// Saat ve dakika biçimlendirmesi (HH:mm)
  String get formattedTime { // get formattedTime : Kayıt zamanını kullanıcıya "09:05" gibi iki haneli saat:dakika formatında döndüren getter.
    final hour = timestamp.hour.toString().padLeft(2, '0'); // Saati alıp tek haneliyse soluna '0' ekler.
    final minute = timestamp.minute.toString().padLeft(2, '0'); // Dakikayı alıp tek haneliyse soluna '0' ekler.
    return '$hour:$minute'; // "HH:mm" formatında birleştirip döndürür.
  }
}

// ÇALIŞMA MANTIĞI: WorkoutController.addWorkout() çağrıldığında yeni bir Workout nesnesi oluşturulur -> WorkoutLogList bu nesnenin title, durationMinutes, caloriesBurned ve formattedTime özelliklerini okuyarak ekranda listeler.

// IMMUTABLE MODEL (`final` alanlar) : Oluşturulduktan sonra verisi bozulamaz veya yanlışlıkla değiştirilemez; durum yönetiminde (State Management) öngörülebilirlik sağlar.
//  VS
// MUTABLE MODEL (`final` olmayan alanlar) : Herhangi bir widget içinden `workout.caloriesBurned = 9999` diyerek `notifyListeners()` tetiklenmeden veri sessizce değiştirilebilir, bu da arayüz ile veri arasında tutarsızlık yaratır.
