// -bu kod bloğunda Piyasalar (Markets) ekranı için sabit kripto varlık ve işlem listelerinin tanımlanması anlatılıyor.-
// StatelessWidget: Durumu (state) değişmeyen, yalnızca verilen sabit verileri ekrana çizen widget türüdür.
// static: Değişkenin nesneye değil doğrudan sınıfa (MarketsGridListScreen) ait olduğunu belirtir; her widget oluşturulduğunda bellekte tekrar kopyalanmaz.
// const: Derleme zamanında (compile-time) değeri kesinleşen ve çalışma zamanında ASLA değiştirilemeyen sabit yapıları tanımlar.

import 'package:flutter/material.dart'; // Flutter Material Design görsel bileşenlerini (Icon, Icons, StatelessWidget vb.) içeri aktarır.
import '../models/asset_model.dart'; // Kripto varlık veri modelini (Asset sınıfı) üst klasördeki models dizininden dahil eder. | HATA NOTU: Bu dosya kök dizinde olduğu için '../models/...' yolu burada geçersiz olabilir; doğru konum lib/screens/ altıdır.
import '../models/transation_model.dart'; // İşlem geçmişi veri modelini (TransactionItem sınıfı) projeye dahil eder.

class MarketsGridListScreen extends StatelessWidget { // MarketsGridListScreen: Piyasalar ekranı sınıfı | extends StatelessWidget: Durumsuz widget özelliklerini miras alır.
  // HATA: StatelessWidget miras alındığı için bu sınıfın içinde mutlaka '@override Widget build(BuildContext context)' metodu tanımlanmalıdır; aksi halde derleme hatası verir.
  const MarketsGridListScreen({super.key}); // const constructor: Widget'ın değişmez (immutable) olarak oluşturulmasını sağlar | super.key: Widget ağacındaki kimlik bilgisini üst sınıfa (StatelessWidget) iletir.

  // HATA: Aşağıdaki satırda 'symbol:'ETH'' sonrasında virgül (,) unutulmuş ve 'Ethereum' metni tırnak ('Ethereum') içine alınmamış!
  // DOĞRU KULLANIM: Asset(symbol: 'ETH', name: 'Ethereum', price: 3500, change24h: -1.80, balance: 4.20)
  // static const List<Asset>: Sınıfa ait, derleme zamanı sabiti olan ve yalnızca Asset tipinde nesneler barındıran liste.
  static const List<Asset> assest=[Asset(symbol:'ETH' name: Ethereum, price: 3500,  change24h: -1.80, balance: 4.20), // assest: Liste değişken adı ('assets' yerine sehven 'assest' yazılmış) | symbol: Kısaltma | price: Güncel fiyat | change24h: 24 saatlik değişim yüzdesi | balance: Cüzdandaki miktar
  Asset(symbol:'Sol', name:'Solana', price: 200.00,  change24h: 0.50, balance: 85.00)]; // Listenin 2. elemanı: Solana kripto varlık nesnesi.

  // static const List<TransactionItem>: Sınıfa ait, değiştirilemez işlem geçmişi (TransactionItem) listesi.
  static const List<TransactionItem> transactions = [
    TransactionItem( // TransactionItem kurucu metodu (constructor) ile yeni bir işlem kaydı oluşturuluyor.
      id: 'tx_1', // id: İşlemin benzersiz kimlik numarası (String)
      title: 'Apple Store', // title: İşlemin yapıldığı yer veya başlığı
      category: 'Teknoloji', // category: Harcama/gelir kategorisi
      date: 'bugün, 14:20', // date: İşlemin gerçekleştiği tarih/saat metni
      amount: 64500, // amount: İşlem tutarı (double olarak 64500.0 şeklinde değerlendirilir)
      isExpense: true, // isExpense: true olduğu için bu işlem bir GİDERDİR (false olsaydı GELİR olarak yeşil renkte gösterilirdi)
      icon: Icons.laptop_mac // icon: İşlemi temsil eden Material ikonu (IconData)
    ),
  ];
}

// ÇALIŞMA MANTIĞI:
// Model sınıfları (Asset, TransactionItem) import edilir -> MarketsGridListScreen içinde static const listeler tanımlanır -> Bellekte tek seferlik sabit veri oluşturulur -> (Eksik olan build() metodu tamamlandığında) bu listeler GridView ve ListView içinde ekrana çizilir.

// ÖNEMLİ:
// 1. İsimlendirilmiş parametreler (named parameters) arasında mutlaka virgül (,) bulunmalıdır (symbol: 'ETH', name: 'Ethereum').
// 2. String (metin) ifadeler mutlaka tek ('...') veya çift ("...") tırnak içine alınmalıdır; aksi halde Dart bunu bir değişken veya sınıf adı sanır (Ethereum hatası).
// 3. StatelessWidget kullanan her sınıf, ekranda ne gösterileceğini belirleyen build() metodunu @override etmek ZORUNDADIR.

// STATIC CONST : Değişken nesneye değil sınıfa aittir, bellekte yalnızca 1 kez oluşturulur ve değeri derleme zamanında sabitlenir.
//  VS
// FINAL : Değişkene çalışma zamanında (runtime) yalnızca 1 kez değer atanabilir, ancak her yeni nesne (instance) için farklı bir değer alabilir.
