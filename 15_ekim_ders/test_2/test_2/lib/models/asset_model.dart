// -bu dosyada kripto para varlıklarının özelliklerini (sembol, isim, fiyat, 24s değişim, bakiye) bir arada tutan Asset veri modeli anlatılıyor.-
// Model Sınıfı (Class): Gerçek dünyadaki bir nesneyi (burada bir kripto parayı) yazılım içinde temsil eden veri şablonudur.
// final: Değişkenin değerinin nesne oluşturulduktan sonra bir daha DEĞİŞTİRİLEMEYECEĞİNİ (immutable / salt okunur) garanti eder.
// const Constructor: Nesnenin tüm özellikleri final olduğu için derleme zamanında (compile-time) sabit nesneler üretilmesini sağlar, bellekte gereksiz kopya oluşmasını engeller.

class Asset { // Asset: Her bir kripto para varlığını temsil eden model sınıfı.
  final String symbol; // symbol: Kripto paranın kısa kodu (Örn: 'BTC', 'ETH', 'SOL') | final: Sonradan değiştirilemez.
  final String name; // name: Kripto paranın tam adı (Örn: 'Bitcoin', 'Ethereum', 'Solana').
  final double price; // price: Birim fiyatı, küsuratlı olabileceği için double (ondalıklı sayı) tipindedir (Örn: 67420.00).
  final double change24h; // change24h: Son 24 saatteki yüzdelik fiyat değişimi (Pozitifse yükseliş: 4.20, negatifse düşüş: -1.80).
  final double balance; // balance: Kullanıcının cüzdanında bulunan kripto para miktarı (Örn: 0.4 BTC).

  // Yapıcı Metot (Constructor): Süslü parantez {} kullanarak isimlendirilmiş parametre (named parameter) alır.
  const Asset({
    required this.symbol, // required: Nesne oluşturulurken 'symbol' verilmesi ZORUNLUDUR | this.symbol: Gelen değeri sınıfın symbol değişkenine atar.
    required this.name, // required: 'name' alanı zorunludur, boş geçilemez.
    required this.price, // required: 'price' alanı zorunludur.
    required this.change24h, // required: 'change24h' alanı zorunludur.
    required this.balance, // required: 'balance' alanı zorunludur.
  });
}

// ÇALIŞMA MANTIĞI:
// Başka bir dosyada Asset(symbol: 'BTC', name: 'Bitcoin', ...) çağrılır -> required alanların hepsi kontrol edilir -> this ile sınıf içindeki final değişkenlere değerler atanır -> Değiştirilemez (immutable) bir Asset nesnesi oluşur -> Piyasalar ekranında asset.name, asset.price şeklinde okunarak kartlara yazdırılır.

// IMMUTABLE MODEL (final değişkenli sınıf) : Nesne bir kez oluşturulduktan sonra içindeki veriler değiştirilemez; güvenli ve öngörülebilirdir (Flutter widget mimarisiyle tam uyumludur).
//  VS
// MUTABLE MODEL (normal değişkenli sınıf) : Nesne oluşturulduktan sonra asset.price = 50000 gibi doğrudan değiştirilebilir; büyük uygulamalarda verinin nerede değiştiğini takip etmek zorlaşır.
