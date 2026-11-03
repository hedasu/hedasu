// -bu kod bloğunda yapılan bir antrenmanın tüm bilgilerini (kimlik, başlık, süre, kalori, zaman, kategori) tutan değişmez (immutable) WorkoutEntryModel sınıfı anlatılıyor.-
// Immutable Veri Modeli: Alanları 'final' olduğu için çalışma zamanında yanlışlıkla değiştirilemeyen güvenli sınıf.
// copyWith(): Nesnenin mevcut özelliklerini koruyarak sadece istenen alanları değiştirilmiş yeni bir kopyasını üreten metot.
// JSON Serileştirme (fromJson / toJson): Nesneyi yerel hafızaya kaydetmek veya sunucuya göndermek için Map<String, dynamic> yapısına çevirme ve geri okuma metotları.

/// Antrenman Kaydı Modeli (Immutable)
class WorkoutEntryModel {
  final String id; // Antrenman kaydının benzersiz kimliği.
  final String title; // Antrenmanın adı (Örn: 'Kardio Koşu').
  final int durationMinutes; // Antrenman süresi (dakika cinsinden).
  final int caloriesBurned; // Antrenmanda yakılan enerji (kalori / kcal cinsinden).
  final DateTime timestamp; // Antrenmanın kaydedildiği tarih ve saat.
  final String category; // İkon seçiminde kullanılan kategori ('strength', 'cardio', 'hiit', 'yoga').

  const WorkoutEntryModel({ // Sabit (const) kurucu metot.
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.timestamp,
    required this.category,
  });

  WorkoutEntryModel copyWith({ // Mevcut antrenman kaydının seçili alanlarını güncelleyip yeni nesne döndürür.
    String? id,
    String? title,
    int? durationMinutes,
    int? caloriesBurned,
    DateTime? timestamp,
    String? category,
  }) {
    return WorkoutEntryModel(
      id: id ?? this.id, // Yeni değer verilmişse onu kullan, null ise mevcut nesnenin değerini (this.id) koru.
      title: title ?? this.title,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      timestamp: timestamp ?? this.timestamp,
      category: category ?? this.category,
    );
  }

  factory WorkoutEntryModel.fromJson(Map<String, dynamic> json) { // JSON (Map) verisinden WorkoutEntryModel nesnesi üretir.
    return WorkoutEntryModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      durationMinutes: json['durationMinutes'] as int? ?? 0,
      caloriesBurned: json['caloriesBurned'] as int? ?? 0,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String) // Tarih metnini DateTime nesnesine çevirir.
          : DateTime.now(),
      category: json['category'] as String? ?? 'strength', // Kategori belirtilmemişse varsayılan olarak 'strength' (ağırlık) atar.
    );
  }

  Map<String, dynamic> toJson() { // Nesneyi JSON (Map) formatına dönüştürür.
    return {
      'id': id,
      'title': title,
      'durationMinutes': durationMinutes,
      'caloriesBurned': caloriesBurned,
      'timestamp': timestamp.toIso8601String(), // Tarihi ISO-8601 standart metnine dönüştürür.
      'category': category,
    };
  }
}

// ÇALIŞMA MANTIĞI:
// Kullanıcı egzersiz eklediğinde WorkoutEntryModel oluşturulur -> WorkoutController içindeki listeye eklenir
// -> WorkoutCard widget'ı bu modelin içindeki title, durationMinutes, caloriesBurned ve category alanlarını okuyarak ekrana çizer.

// NORMAL KURUCU (WorkoutEntryModel(...)) : Her zaman doğrudan verilen parametrelerle yeni bir nesne oluşturur
//  VS
// FACTORY KURUCU (WorkoutEntryModel.fromJson(...)) : Dışarıdan gelen ham veriyi (Map) önce işler, null kontrollerini yapar ve uygun nesneyi üretip döndürür
