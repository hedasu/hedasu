// -bu dosyada tek bir su tüketim veya düzeltme işlemini temsil eden değişmez (immutable) WaterLog veri modeli ve saat biçimlendirme (formattedTime) mantığı anlatılıyor.-
// padLeft(uzunluk, karakter) : Bir metnin karakter sayısı belirtilen uzunluktan azsa, sol tarafına belirtilen karakteri ekleyerek tamamlar (Örn: `'5'.padLeft(2, '0')` -> `'05'` üretir; saat gösteriminde `9:5` yerine `09:05` yazmak için kullanılır).
// DateTime : Dart dilinde tarih ve saat bilgisini (yıl, ay, gün, saat, dakika, saniye) tutan yerleşik sınıftır.

/// Su tüketim kaydını temsil eden değişmez (immutable) veri modeli.
class WaterLog { // class WaterLog : Her bir su ekleme veya azaltma işleminin verilerini bir arada tutan model sınıfı.
  const WaterLog({ // const kurucu : Nesnenin tüm alanları final olduğu için değişmez (immutable) olarak oluşturulmasını sağlar.
    required this.id, // Kaydı silerken (removeLog) ayırt etmeyi sağlayan benzersiz kimlik.
    required this.amountMl, // Eklenen (+200) veya azaltılan (-100) mililitre cinsinden su miktarı.
    required this.timestamp, // İşlemin yapıldığı tarih ve saat (DateTime nesnesi).
    required this.label, // İşlemin açıklaması (Örn: 'Bardak', 'Matara', 'Yanlış Ekleme Düzeltmesi').
  });

  final String id; // final : Benzersiz kayıt ID'si.
  final int amountMl; // final : Mililitre miktarı (pozitif veya negatif tam sayı).
  final DateTime timestamp; // final : Kayıt zamanı.
  final String label; // final : Kayıt etiketi.

  /// Saat ve dakika biçimlendirmesi (HH:mm)
  String get formattedTime { // get formattedTime : `timestamp` içindeki saat ve dakikayı "14:05" formatında okunabilir metne çeviren hesaplanmış özellik (getter).
    final hour = timestamp.hour.toString().padLeft(2, '0'); // Saati (0-23) String'e çevirir, tek haneliyse başına '0' ekler (Örn: 9 -> "09").
    final minute = timestamp.minute.toString().padLeft(2, '0'); // Dakikayı (0-59) String'e çevirir, tek haneliyse başına '0' ekler (Örn: 7 -> "07").
    return '$hour:$minute'; // Saat ve dakikayı araya iki nokta koyarak birleştirir (Örn: "09:07").
  }
}

// ÇALIŞMA MANTIĞI: WaterTrackerController su eklendiğinde DateTime.now() ile bir WaterLog üretir -> WaterLogHistory listesi bu nesneyi alır -> Ekranda saati göstermek için log.formattedTime çağrılır -> padLeft ile "HH:mm" formatında ekrana yazılır.

// MODEL İÇİNDE GETTER (`log.formattedTime`) : Saat formatlama mantığı tek bir yerde (modelin içinde) yazılır; hangi ekranda çağrılırsa çağrılsın hazır formatlı gelir (DRY - Kendini Tekrar Etme prensibi).
//  VS
// UI İÇİNDE FORMATLAMA : Her Text widget'ının içinde tekrar tekrar `padLeft` yazmaktır; kod tekrarına ve karmaşaya yol açar.
