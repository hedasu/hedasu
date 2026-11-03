// -bu kod bloğunda bir başarı rozetinin tüm özelliklerini (kimlik, başlık, açıklama, ikon, kilit durumu) temsil eden değişmez (immutable) BadgeModel sınıfı anlatılıyor.-
// Immutable (Değişmez) Sınıf: Tüm değişkenleri 'final' olan, oluşturulduktan sonra iç durumu değiştirilemeyen güvenli veri modeli.
// copyWith(): Nesnenin mevcut değerlerini koruyup, sadece parametre olarak verilen alanlarını güncelleyerek YENİ bir nesne döndüren metot.
// DateTime.tryParse(): Bir metni (String) tarihe (DateTime) çevirmeyi dener; eğer metin bozuksa uygulama çökmez (hata fırlatmaz), güvenlice null döndürür.

/// Rozet Modeli (Immutable)
class BadgeModel {
  final String id; // Rozetin benzersiz kimlik kodu (Örn: 'water_first').
  final String title; // Rozetin ekranda görünen başlığı (Örn: 'İlk Damla').
  final String description; // Rozetin nasıl kazanıldığını anlatan açıklama metni.
  final String iconName; // Rozetin ikonunu belirleyen anahtar kelime (Örn: 'water_drop').
  final bool isUnlocked; // Rozetin kazanılıp kazanılmadığını tutan durum (true: açık, false: kilitli).
  final String category; // Rozetin ait olduğu kategori ('water', 'workout', 'special').
  final DateTime? unlockedAt; // Rozetin kazanıldığı tarih ve saat. | DateTime?: Henüz kazanılmadıysa null olabileceği için soru işareti (?) konur.

  const BadgeModel({ // const: Sabit rozet tanımlamaları yapabilmek için const kurucu kullanılır.
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    this.isUnlocked = false, // Varsayılan değer: Rozet ilk oluşturulduğunda aksi belirtilmedikçe kilitlidir (false).
    required this.category,
    this.unlockedAt, // required değildir çünkü kilitli rozetlerin kazanılma tarihi henüz yoktur (null).
  });

  BadgeModel copyWith({ // Rozetin kilidi açıldığında mevcut rozetten yeni bir açık rozet üretmek için kullanılır.
    String? id,
    String? title,
    String? description,
    String? iconName,
    bool? isUnlocked,
    String? category,
    DateTime? unlockedAt,
  }) {
    return BadgeModel(
      id: id ?? this.id, // Yeni id verilmişse onu al, null ise mevcut id'yi (this.id) kullan.
      title: title ?? this.title,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      category: category ?? this.category,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  factory BadgeModel.fromJson(Map<String, dynamic> json) { // JSON (Map) verisinden BadgeModel nesnesi üreten factory kurucu.
    return BadgeModel(
      id: json['id'] as String? ?? '', // JSON'da 'id' yoksa veya null ise boş String ('') ata.
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      iconName: json['iconName'] as String? ?? 'military_tech', // İkon adı belirtilmemişse varsayılan madalya ikonunu kullan.
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      category: json['category'] as String? ?? 'general',
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.tryParse(json['unlockedAt'] as String) // tryParse: Geçersiz tarih formatı gelirse hata vermek yerine null döner.
          : null,
    );
  }

  Map<String, dynamic> toJson() { // BadgeModel nesnesini JSON (Map) formatına dönüştürür.
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconName': iconName,
      'isUnlocked': isUnlocked,
      'category': category,
      'unlockedAt': unlockedAt?.toIso8601String(), // ?.: Null-aware erişim. unlockedAt null değilse metne çevir, null ise doğrudan null bırak.
    };
  }
}

// ÇALIŞMA MANTIĞI:
// Başlangıçta const BadgeModel(isUnlocked: false) ile kilitli rozet oluşturulur
// -> Kullanıcı hedefi tamamlar -> badge.copyWith(isUnlocked: true, unlockedAt: DateTime.now()) çağrılır
// -> Eski nesne bozulmadan kilidi açılmış yeni BadgeModel nesnesi elde edilir.

// DATETIME.PARSE() : Metin geçerli bir tarih formatında değilse FormatException hatası fırlatır ve uygulamayı durdurabilir
//  VS
// DATETIME.TRYPARSE() : Metin bozuksa uygulama çökmez, sessizce null döndürür; dış veri (JSON) okurken çok daha güvenlidir
