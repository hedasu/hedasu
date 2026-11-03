/*
WIDGET TEST (WIDGET TESTİ)

* Flutter uygulamasındaki widget'ların doğru çalışıp
  çalışmadığını otomatik olarak kontrol etmek için kullanılır.

* Bu dosyada Counter (Sayaç) uygulamamızı test ediyoruz.

* Testin amacı:
  1. Uygulamayı test ortamında oluşturmak.
  2. Sayacın başlangıçta 0 olduğunu kontrol etmek.
  3. Kullanıcı "+" butonuna basmış gibi işlem yapmak.
  4. Sayacın 1 olup olmadığını kontrol etmek.

* Widget Test:
  Uygulamayı gerçek bir telefonda açmak zorunda kalmadan
  widget'ların davranışlarını test etmemizi sağlar.

* WidgetTester:
  Test sırasında kullanıcı etkileşimlerini taklit eder.
  Örneğin: Tıklama (tap), kaydırma (scroll).

* Ayrıca ekrandaki widget'ları bulabilir ve
  beklediğimiz sonuçların oluşup oluşmadığını kontrol edebilir.
*/

import 'package:flutter/material.dart';
// Flutter'ın Material Design kütüphanesini dahil eder.
// Icon, Icons.add ve diğer Material bileşenlerini kullanabiliriz.

import 'package:flutter_test/flutter_test.dart';
// flutter_test = Flutter'ın test kütüphanesidir.
//
// Test yazmak için gerekli araçları sağlar.
//
// Örneğin:
// testWidgets()  → Widget testi oluşturur.
// WidgetTester   → Kullanıcı etkileşimlerini simüle eder.
// expect()       → Beklenen sonucu kontrol eder.
// find           → Widget ağacında widget arar.
// findsOneWidget → Tam olarak bir eşleşme bekler.
// findsNothing   → Hiç eşleşme beklemez.

import 'package:test/main.dart';

// Kendi uygulamamızın main.dart dosyasını içeri aktarır.
//
// Buradaki test = Projenin paket adı.
//
// main.dart içerisinde MyApp sınıfımız bulunuyor.
//
// ÖNEMLİ:
// Bu import, uygulamamızdaki MyApp widget'ını
// test dosyasında kullanabilmemizi sağlar.

// ============================================================
// 1. TESTİN BAŞLANGIÇ NOKTASI
// ============================================================

void main() {
  // main() = Bu test dosyasının çalışmaya başladığı fonksiyon.
  //
  // void = Fonksiyon geriye bir değer döndürmez.
  //
  // ÖNEMLİ:
  // Uygulamanın main() fonksiyonu ile
  // test dosyasının main() fonksiyonu farklıdır.
  //
  // Uygulamada main() → runApp() ile uygulamayı başlatır.
  // Testte main() → testWidgets() ile testleri tanımlar.

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // testWidgets() = Flutter'da widget testi tanımlar.
    //
    // 'Counter increments smoke test'
    // Testimize verdiğimiz isimdir.
    //
    // Counter = Sayaç.
    // increments = Artar.
    // smoke test = Temel işlevlerin çalışıp çalışmadığını
    // hızlıca kontrol eden test.
    //
    // Yani testin amacı:
    // "Sayaç artırma işlemi doğru çalışıyor mu?"
    //
    // WidgetTester tester:
    // WidgetTester türünde tester parametresini alır.
    //
    // tester = Test ortamında uygulamayla etkileşim
    // kurmamızı sağlayan nesne.
    //
    // Örneğin:
    // tester.tap()        → Bir widget'a dokunur.
    // tester.pump()       → Yeni bir frame oluşturur.
    // tester.pumpWidget() → Widget'ı test ortamına yerleştirir.
    //
    // async = Asenkron (eşzamansız) fonksiyon.
    //
    // Fonksiyon içerisinde await kullanılabilmesini sağlar.
    //
    // Bazı test işlemleri hemen tamamlanmayabilir.
    // Bu işlemlerin tamamlanmasını beklememiz gerekir.

    // ========================================================
    // 2. UYGULAMAYI TEST ORTAMINDA OLUŞTURMA
    // ========================================================

    // Build our app and trigger a frame.
    // Uygulamamızı oluşturur ve ilk frame'i çalıştırır.

    await tester.pumpWidget(const MyApp());
    // await = Asenkron işlemin tamamlanmasını bekler.
    //
    // tester.pumpWidget() =
    // Verilen widget'ı test ortamının köküne yerleştirir.
    //
    // const MyApp() =
    // MyApp sınıfından sabit bir widget nesnesi oluşturur.
    //
    // pumpWidget, widget ağacını oluşturup ilk frame'i işler.
    //
    // Frame = Flutter'ın arayüzü oluşturma ve güncelleme döngüsü.
    //
    // ÖNEMLİ:
    // Bu işlem gerçek bir Android/iOS uygulaması açmaz.
    // Flutter'ın widget test ortamında çalışır.
    //
    // Bu satır tamamlandığında uygulamamızın
    // başlangıç arayüzü test edilmeye hazırdır.

    // ========================================================
    // 3. BAŞLANGIÇ DEĞERİNİ KONTROL ETME
    // ========================================================

    // Verify that our counter starts at 0.
    // Sayacın başlangıçta 0 olduğunu doğrular.

    expect(find.text('0'), findsOneWidget);
    // expect() = Beklenen sonuç ile gerçek sonucu karşılaştırır.
    //
    // find.text('0') =
    // Widget Tree içerisinde metni tam olarak "0"
    // olan Text widget'ını arar.
    //
    // findsOneWidget =
    // Aranan widget'tan TAM OLARAK bir tane bulunmalı.
    //
    // Yani:
    // "Ekranda 0 yazan tam bir Text widget'ı var mı?"
    //
    // Varsa → TEST BAŞARILI.
    // Yoksa veya birden fazlaysa → TEST BAŞARISIZ.
    //
    // ÖNEMLİ:
    // Burada 0'ın matematiksel değerini değil,
    // ekranda gösterilen '0' metnini kontrol ediyoruz.

    expect(find.text('1'), findsNothing);
    // find.text('1') =
    // Ekranda metni "1" olan widget'ı arar.
    //
    // findsNothing =
    // Aranan widget'tan hiç bulunmamasını bekler.
    //
    // Yani:
    // "Sayaç henüz artırılmadığı için ekranda 1 olmamalı."
    //
    // Eğer "1" bulunursa → TEST BAŞARISIZ.
    //
    // NEDEN İKİ KONTROL YAPIYORUZ?
    // İlk kontrol → 0'ın var olduğunu doğrular.
    // İkinci kontrol → 1'in henüz olmadığını doğrular.

    // ========================================================
    // 4. KULLANICININ BUTONA BASMASINI TAKLİT ETME
    // ========================================================

    // Tap the '+' icon and trigger a frame.
    // "+" ikonuna dokunur ve yeni bir frame çalıştırır.

    await tester.tap(find.byIcon(Icons.add));
    // tester.tap() =
    // Kullanıcının ekrana dokunmasını simüle eder.
    //
    // find.byIcon(Icons.add) =
    // Widget ağacında Icons.add ikonunu kullanan
    // Icon widget'ını arar.
    //
    // Icons.add = Artı (+) ikonu.
    //
    // Yani:
    // "Uygulamadaki + ikonunun üzerine dokun."
    //
    // Bizim uygulamamızda bu ikon
    // FloatingActionButton içerisinde bulunuyor.
    //
    // İkona dokunulunca butonun onPressed işlemi tetiklenir.
    //
    // onPressed: _incrementCounter
    //
    // Böylece _incrementCounter() metodu çalışır.
    //
    // Metodun içerisinde:
    //
    // setState(() {
    //   _counter++;
    // });
    //
    // setState() = Durum değişikliğini Flutter'a bildirir.
    // _counter++ = Sayacı bir artırır.
    //
    // ÖNEMLİ:
    // tester.tap(), butona dokunma olayını gönderir.
    // Arayüzün yeniden çizilmesini tek başına garanti etmez.

    await tester.pump();
    // pump() = Test ortamında bir frame çalıştırır.
    //
    // NEDEN GEREKLİ?
    //
    // Az önce butona bastık ve setState() çağrıldı.
    //
    // setState() ilgili Element'ı yeniden build
    // yapılması için işaretler.
    //
    // Ancak güncellenmiş arayüzü test edebilmek için
    // yeni frame'in işlenmesi gerekir.
    //
    // tester.pump() bu işlemi gerçekleştirir.
    //
    // ÇALIŞMA SIRASI:
    //
    // 1. tester.tap() ile butona basılır.
    // 2. _incrementCounter() çağrılır.
    // 3. setState() içerisinde _counter artırılır.
    // 4. Flutter yeniden build yapılmasını planlar.
    // 5. tester.pump() yeni frame'i işler.
    // 6. Text widget'ı yeni sayaç değerini gösterir.
    //
    // ÖNEMLİ:
    // pump() her şeyi sıfırdan oluşturmaz.
    // Uygun Element ve State nesneleri korunabilir.
    //
    // Bizim sayaç örneğimizde State yaşamaya devam eder.

    // ========================================================
    // 5. SAYACIN ARTIP ARTMADIĞINI KONTROL ETME
    // ========================================================

    // Verify that our counter has incremented.
    // Sayacın gerçekten artırıldığını doğrular.

    expect(find.text('0'), findsNothing);
    // Ekranda artık "0" yazan Text widget'ı olmamalı.
    //
    // Çünkü:
    // Başlangıç → _counter = 0
    // Butona basıldı → _counter = 1
    //
    // 0 hâlâ görünüyorsa:
    // Arayüz güncellenmemiş veya beklenen işlem
    // gerçekleşmemiş olabilir.
    //
    // Bu durumda test başarısız olur.

    expect(find.text('1'), findsOneWidget);
    // Ekranda "1" yazan tam bir Text widget'ı bulunmalı.
    //
    // Çünkü "+" butonuna bir kez bastık.
    //
    // _counter++ işlemi:
    // 0 + 1 = 1
    //
    // Sonuç doğruysa test başarılı olur.
    //
    // ÖNEMLİ:
    // Bu kontrol yalnızca _counter değişkeninin
    // değiştiğini değil, yeni değerin widget ağacına
    // yansıtıldığını da doğrular.
  });
  // testWidgets() fonksiyonuna verdiğimiz test tamamlandı.
}
// main() sona erdi.
