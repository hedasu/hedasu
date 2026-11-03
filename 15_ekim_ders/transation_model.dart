// -bu dosyada finans/cüzdan uygulamasındaki para transferi ve harcama işlemlerini temsil eden veri modeli (TransactionItem) anlatılıyor.-
// Veri Modeli (Data Model): Uygulamadaki dağınık verileri (başlık, tutar, tarih, ikon vb.) tek bir çatı altında toplayan düzenli sınıf şablonudur.
// final: Değişkene yalnızca BİR KEZ (nesne oluşturulurken constructor içinde) değer atanabileceğini, sonradan değiştirilemeyeceğini (immutable) belirtir.
// required: Nesne oluşturulurken bu parametrenin verilmesinin ZORUNLU olduğunu belirtir (boş/null geçilemez).
// const Constructor: Tüm alanları final olduğu için nesnelerin derleme zamanında (compile-time) sabit olarak oluşturulmasına ve performans artışına olanak tanır.

import 'package:flutter/material.dart'; // IconData sınıfını kullanabilmek için Flutter Material kütüphanesini dahil ediyoruz.

class TransactionItem { // TransactionItem: Tek bir finansal işlemi (gelir veya gider) temsil eden model sınıfı.
  final String id; // id: İşlemin benzersiz kimliği (Örn: 'tx_1', 'tx_2') | final: Oluşturulduktan sonra değiştirilemez.
  final String title; // title: İşlem başlığı veya alıcı/satıcı adı (Örn: 'Apple Store', 'Ahmet Yılmaz').
  final String category; // category: İşlemin ait olduğu kategori (Örn: 'Teknoloji', 'Hızlı Transfer').
  final String date; // date: İşlemin gerçekleştiği tarih ve saat bilgisi (Örn: 'bugün 14:20').
  final double amount; // amount: İşlemin parasal tutarı (ondalıklı sayı - double).
  final bool isExpense; // isExpense: İşlem gider mi? (true -> Gider / Kırmızı ve '-' işareti | false -> Gelir / Yeşil ve '+' işareti).
  final IconData icon; // icon: İşlem kartının solunda gösterilecek ikon verisi (Örn: Icons.laptop_mac, Icons.send_rounded).

  // Yapıcı Metot (Constructor): Süslü parantezler {} sayesinde isimlendirilmiş parametre (named parameter) kullanılır.
  // (Eğer {} kullanılmasaydı parametreleri sırasını ezberleyerek göndermek zorunda kalırdık: TransactionItem('tx_1', 'Apple', ...))
  const TransactionItem({
    required this.id, // this.id: Dışarıdan gelen 'id' değerini doğrudan sınıfın içindeki 'final String id' değişkenine atar.
    required this.title, // required: Bu alan verilmeden TransactionItem nesnesi OLUŞTURULAMAZ.
    required this.category, // this.category: Sınıfın category alanını başlatır.
    required this.date, // this.date: Sınıfın date alanını başlatır.
    required this.amount, // this.amount: Sınıfın amount alanını başlatır.
    required this.isExpense, // this.isExpense: Sınıfın gelir/gider durumunu başlatır.
    required this.icon, // this.icon: Sınıfın ikon bilgisini başlatır.
  });
}

// ÇALIŞMA MANTIĞI:
// TransactionItem(...) çağrılır -> required parametreler eksiksiz girilir -> this anahtar kelimesi ile sınıfın final değişkenlerine atanır -> Değiştirilemez (immutable) bir işlem nesnesi oluşur -> UI ekranlarında (ListView içinde) transaction.title, transaction.amount şeklinde okunarak ekrana çizilir.

// ÖNEMLİ:
// Model sınıflarında alanların 'final' yapılması, verinin uygulama içinde yanlışlıkla değiştirilmesini (yan etkileri / side-effects) önler.
// Bir alanı güncellemek gerekirse mevcut nesneyi değiştirmek yerine yeni bir TransactionItem nesnesi oluşturulur.

// NAMED PARAMETERS ({required this.id}) : Parametreler isimleriyle çağrılır (id: 'tx_1'), sıra önemli değildir, okunabilirliği çok yüksektir.
//  VS
// POSITIONAL PARAMETERS (this.id) : Parametreler sırasıyla yazılır ('tx_1'), isim yazılmaz, parametre sayısı arttıkça hangi değerin ne olduğu karışabilir.
