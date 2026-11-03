// -bu kod bloğunda tek bir su tüketim işleminin verilerini (kimlik, miktar, zaman, etiket) taşıyan değişmez (immutable) WaterEntryModel sınıfı anlatılıyor.-
// Immutable Model: İçindeki tüm değişkenlerin 'final' olarak tanımlandığı, oluşturulduktan sonra değiştirilemeyen veri modeli.
// copyWith(): Mevcut nesnenin kopyasını oluştururken sadece istenen alanları değiştirmeye yarayan metot.
// fromJson / toJson: Nesneyi JSON (Map<String, dynamic>) formatından okumak ve JSON formatına dönüştürmek için kullanılan serileştirme metotları.

/// Su Tüketim Kaydı Modeli (Immutable)
class WaterEntryModel {
  final String id; // Su kaydının benzersiz kimliği.
  final int amountMl; // İçilen su miktarı (mililitre).
  final DateTime timestamp; // Suyun içildiği tarih ve saat.
  final String label; // Suyun kap/tür etiketi (Örn: 'Bardak (200ml)', 'Matara (500ml)').

  const WaterEntryModel({ // Sabit (const) kurucu metot.
    required this.id, // required: Bu parametrelerin verilmesi zorunludur.
    required this.amountMl,
    required this.timestamp,
    required this.label,
  });

  WaterEntryModel copyWith({ // Nesnenin belirli alanlarını güncelleyerek yeni bir WaterEntryModel döndürür.
    String? id,
    int? amountMl,
    DateTime? timestamp,
    String? label,
  }) {
    return WaterEntryModel(
      id: id ?? this.id, // Parametre verilmişse (null değilse) yeni değeri, verilmemişse mevcut değeri (this.id) kullan.
      amountMl: amountMl ?? this.amountMl,
      timestamp: timestamp ?? this.timestamp,
      label: label ?? this.label,
    );
  }

  factory WaterEntryModel.fromJson(Map<String, dynamic> json) { // JSON haritasından WaterEntryModel nesnesi üreten factory kurucu.
    return WaterEntryModel(
      id: json['id'] as String? ?? '', // 'id' null ise boş metin ('') ata.
      amountMl: json['amountMl'] as int? ?? 0, // 'amountMl' null ise 0 ata.
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String) // Metin halindeki tarihi DateTime nesnesine çevir.
          : DateTime.now(), // Tarih yoksa şu anki zamanı kullan.
      label: json['label'] as String? ?? 'Bardak Su', // Etiket yoksa 'Bardak Su' kullan.
    );
  }

  Map<String, dynamic> toJson() { // Nesneyi JSON (anahtar-değer haritası) formatına çevirir.
    return {
      'id': id,
      'amountMl': amountMl,
      'timestamp': timestamp.toIso8601String(), // Tarihi standart ISO-8601 metin formatına çevirir.
      'label': label,
    };
  }
}

// ÇALIŞMA MANTIĞI:
// Su eklendiğinde WaterEntryModel(...) kurucusu ile nesne üretilir -> history listesine eklenir
// -> Kalıcı depolamaya kaydedilecekse toJson() ile Map'e çevrilir -> Okunurken fromJson() ile tekrar modele dönüştürülür.

// TOJSON() : Dart nesnesini (WaterEntryModel) dış dünyaya/veritabanına kaydetmek için Map<String, dynamic> yapısına çevirir
//  VS
// FROMJSON() : Dış dünyadan gelen Map<String, dynamic> verisini uygulama içinde kullanmak için güvenli Dart nesnesine çevirir
