// SOYUTLAMA (ABSTRACTION): Bir işlemin NE YAPACAĞINI belirleyip NASIL YAPILACAĞINI ilgili sınıflara bırakma.
// Örneğin giriş yapılacağını biliriz ama Firebase ile mi, sahte test sistemiyle mi yapılacağını ilgili sınıf belirler.
// AMAÇ: Kodlar birbirine daha az bağımlı olsun, sistemi değiştirmek ve test etmek kolaylaşsın.

/**
 // 1. adım Contract (Sözleşmeler)

 abstract class AutReposity{ // abstract class: soyut sınıf oluşturur. DOĞRUDAN NESNESİ OLUŞTURULAMAZ. Ortak kuralları belirler.
   Future<String>login(String email,String password); // login(): email ve password alır. Future<String>: asenkron işlem tamamlanınca String döndürür. {} YOK çünkü burada sadece metot sözleşmesi tanımlanıyor.
   Future<void>logout(); // logout(): çıkış işlemi için zorunlu metot. Future<void>: asenkron tamamlanır ama sonuç değeri döndürmez.
   bool get isAuth; // bool: true/false. get: getter tanımlar. isAuth özelliğine fonksiyon gibi () kullanmadan erişebiliriz.
 }
 // ÖNEMLİ: abstract class burada login/logout işlemlerinin NASIL yapılacağını söylemez. Sadece bu üyelerin bulunmasını şart koşar.

 class FirebaseAuthRepository implements AutReposity{ // implements: AutReposity sözleşmesini uygular. login(), logout() ve isAuth üyelerini tanımlamak ZORUNDADIR.
     @override // üst sınıf/arayüzde tanımlanan üyeyi burada yeniden uyguladığımızı belirtir.
     Future<String> login(String email, String password) async{ // login(): iki String parametre alır. async: await kullanımına izin verir, Future döndüren fonksiyon oluşturur.
         //gerçek Firebase SDK Çağrısı
         // NOT: Burada gerçekten Firebase'e bağlanılmıyor, sadece örnek token döndürülüyor.
         return "firebase_token_xyz_123"; // return: işlemin sonucunu döndürür. Future<String> olduğu için String sonuç veriliyor.
     }

     @override
     Future<void> logout async { // HATA: logout sonrasında () eksik. Doğru sözdizimi Future<void> logout() async {...}
         //Firebase logout
         // Gerçek uygulamada Firebase üzerinden oturum kapatma işlemi burada gerçekleştirilirdi.
     }

     @override
     bool get isAuth => true; // get: özellik gibi erişim sağlar. =>: tek ifadeli getter'ı kısa yazma şekli. true: kullanıcı giriş yapmış kabul ediliyor.
 }
 // NOT: isAuth burada HER ZAMAN true döner, gerçek kullanıcı oturumunu kontrol etmez.

 // test ve offline simülasyon

 class MockAuthReposity implements AutReposity{ // Mock: gerçek servis yerine kullanılan TEST AMAÇLI SAHTE yapı. implements: aynı sözleşmeye uymak zorunda.
     @override
     Future<String> login(String email,String password) async{ // gerçek Firebase bağlantısı olmadan giriş işlemini taklit eder.
         await Future.delayed(Duration(second:1)); // Future.delayed(): belirli süre bekleyen Future oluşturur. await: tamamlanmasını bekler. HATA: second değil seconds yazılmalı.
         return "mock_token_abc_789"; // gerçek token değil, test için oluşturulmuş sahte token.
     }

     @override
     Future<void> logout() async{} // logout sözleşmesini karşılıyor ancak içi BOŞ. Gerçekte herhangi bir çıkış işlemi yapılmıyor.

     @override
     bool get isAuth => false; // kullanıcı giriş yapmamış kabul ediliyor. HER ZAMAN false döner.
 }

 // ÇALIŞMA MANTIĞI:
 // AutReposity sözleşme oluşturur -> FirebaseAuthRepository gerçek sistem için uygular
 // -> MockAuthReposity test sistemi için uygular -> ikisi de aynı login/logout/isAuth üyelerini sunar.

 // ÖNEMLİ:
 // abstract class -> ortak yapı/sözleşme oluşturur.
 // implements -> belirtilen sınıfın arayüzünü uygulamayı zorunlu kılar.
 // @override -> var olan üyenin yeniden tanımlandığını belirtir.
 // Mock -> gerçek servise bağlanmadan test yapabilmemizi sağlar.
 // FirebaseAuthRepository ve MockAuthReposity birbirinin alternatifi olarak kullanılabilir.
 // implements, metotların gövdelerini otomatik olarak devralmaz. Gerekli üyeler yeniden uygulanır.
 */

/**
 mixin Logger { // mixin: birden fazla sınıfta kullanılabilecek hazır davranışları tanımlar. KALITIM ALMADAN özellik eklemek için kullanılır.
     void log(String msg)=>print("LOG:$msg"); // log(): String parametre alır, ekrana yazar. void: değer döndürmez. =>: tek ifadeli metodu kısa yazma.
 }

 mixin Analytics{ // Analytics isminde ikinci mixin oluşturuluyor.
     void log(String msg)=>print("Analiz: $msg"); // Logger ile AYNI İSİMDE log() metodu var ama ekrana farklı metin yazdırıyor.
 }

 class PaymentService with Logger,Analytics{ // with: sınıfa mixin'lerin özelliklerini ekler. Logger ve Analytics birlikte kullanılıyor.
     void pay(){ // pay(): ödeme işlemini temsil eden metot.
         log("Ödeme Yapıldı"); // log() çağrılır. İKİ MIXIN'DE DE log() OLDUĞU İÇİN SAĞDAKİ Analytics ÖNCELİKLİDİR.
     }
 }

 // ÖRNEK:
 // final payment = PaymentService();
 // payment.pay();
 // ÇIKTI: Analiz: Ödeme Yapıldı

 // ÖNEMLİ: with Logger,Analytics -> Analytics içindeki log() kullanılır.
 // with Analytics,Logger olsaydı -> Logger içindeki log() kullanılırdı.
 // MIXIN SIRASI ÖNEMLİDİR. Aynı isimli üyelerde sağdaki mixin önceliklidir.


 abstract class BaseWidget{ // soyut temel sınıf. İçinde zorunlu metot yok ama sınıflar için ortak bir temel tür oluşturabilir.

 }

 // sadec BaseWidgetve alt sınıflarda kullanılabilir

 mixin LifeLogger with BaseWidget{ // HATA: mixin tanımlarken burada with değil on kullanılmalı.
     void logInit() => print("Widget Başlatıldı"); // logInit(): çağrıldığında ekrana Widget Başlatıldı yazdırır.
 }

 // DOĞRU MANTIK: mixin LifeLogger on BaseWidget
 // on: mixin'in hangi temel sınıfa/türe sahip yapılarda kullanılabileceğini kısıtlar.
 // Örneğin class MyWidget extends BaseWidget with LifeLogger {} şeklinde kullanılabilir.
 // BaseWidget ile uygun kalıtım ilişkisi olmayan bir sınıfta LifeLogger kullanılamaz.

 // EXTENDS VS IMPLEMENTS VS WITH VS ON:
 // extends -> bir sınıftan KALITIM almak.
 // implements -> bir sınıfın ARAYÜZÜNÜ uygulamak, gerekli üyeleri tanımlamak.
 // with -> mixin içindeki hazır davranışları sınıfa eklemek.
 // on -> mixin'in uygulanabileceği temel türü kısıtlamak.
 */

/**
 extension StringValidator on String{ // extension: mevcut bir türe, kaynak kodunu değiştirmeden yeni özellik/metot ekler. on String: bu özellikler String üzerinde kullanılabilir.
     bool get isValidEmail{ // bool: true/false döner. get: getter oluşturur, email.isValidEmail şeklinde () olmadan kullanılır.
         final emailRegex=RegExp(jfırkjedgkr); // RegExp: belirli metin kalıplarını kontrol etmek için kullanılır. HATA: jfırkjedgkr geçerli bir regex metni olarak tanımlanmamış.
         return emailRegex.hasMatch(this); // hasMatch(): metnin regex kuralına uyup uymadığını kontrol eder. this: kontrol edilen String değeridir.
     }

     String toCapitalize(){ // toCapitalize(): String döndüren, metnin ilk harfini büyütmek için oluşturulmuş metot.
         if(isEmpty) return this; // isEmpty: String boş mu kontrol eder. Boşsa olduğu gibi döndürür. BOŞ STRING'İN İLK KARAKTERİNE ERİŞİLEMEZ.
         return this[0].toUpperCase() + substring(1); // this[0]: ilk karakter. toUpperCase(): büyük harfe çevirir. substring(1): ilk karakterden sonrasını alır. +: ikisini birleştirir.
     }
 }

 // ÖRNEK: "elif".toCapitalize()
 // this[0] -> "e"
 // toUpperCase() -> "E"
 // substring(1) -> "lif"
 // SONUÇ -> "Elif"

 // Kullanımı
 void main(){ // programın başlangıç noktası.
     String email="selahaddin@advance.com"; // String türünde email değişkeni oluşturuluyor.
     if(email.isValidEmail){ // extension ile tanımladığımız getter çağrılır. true ise if bloğuna girer.
         print("Geçerli Eposta"); // email biçimi kontrolü başarılıysa yazdırılır.

     }else{ // if koşulu false olduğunda çalışır.
         print("Geçersiz Eposta"); // email biçimi kontrolü başarısızsa yazdırılır.
     }
 }

 // ÇALIŞMA SIRASI:
 // email değişkeni oluşturulur -> email.isValidEmail çağrılır
 // -> RegExp.hasMatch(this) kontrolü yapılır
 // -> true ise Geçerli Eposta / false ise Geçersiz Eposta yazdırılır.

 // ÖNEMLİ:
 // extension -> hazır String sınıfını değiştirmeden yeni özellik ekler.
 // get -> metodu özellik gibi kullanmamızı sağlar, () YAZMAYIZ.
 // this -> üzerinde işlem yapılan String değerini temsil eder.
 // RegExp -> belirli metin biçimlerini kontrol eder.
 // Regex kontrolü e-posta adresinin gerçekten var olduğunu GARANTİ ETMEZ, sadece biçimini kontrol eder.
 */

/**
 abstract class Identifiable { // soyut sınıf. ID özelliği için ortak sözleşme oluşturur.
   String get id; // id isminde String türünde getter bulunmasını zorunlu tutar (implements kullanıldığında).
 }

 // T tipi Mutlaqka Identifiable arayüzünü uygulamak ZORUNDA
 class GenericCache <T extends Identifiable> { // GenericCache: farklı veri tipleriyle çalışabilen sınıf. T: sonradan belirlenecek tür. extends Identifiable: T türü Identifiable alt türü olmalı.
   final Map<String, T> _storage = {}; // Map: anahtar-değer şeklinde veri tutar. String: anahtar (ID). T: saklanacak nesnenin türü. {}: boş Map oluşturur.
   // final: _storage değişkenine başka Map atanamaz ANCAK mevcut Map'in içine yeni veri eklenebilir.
   // _: Dart'ta library düzeyinde private (özel) üyeyi belirtir. Genellikle sınıf içi kullanım için yazılır.

   void save(T item) { // save(): T türünde bir nesne alır, geriye değer döndürmez.
     _storage[item.id] = item; // item.id: nesnenin kimliği. Map içine ID anahtarıyla nesne kaydedilir. AYNI ID TEKRAR KULLANILIRSA ESKİ DEĞERİN ÜZERİNE YAZILIR.
     print("ID:${item.id} önbelleğe alındı"); // kaydedilen nesnenin ID'sini ekrana yazdırır. ${item.id}: String interpolation, değişken/ifadeyi metne ekler.
   }

   T? getById(String id) => _storage[id]; // getById(): verilen ID'ye göre nesneyi bulur. T?: T türünde nesne VEYA null dönebilir. =>: tek ifadeli metot.
 }. // HATA: class kapanışındaki nokta (.) fazladan yazılmış.

 // GENERIC NE İŞE YARAR?
 // Aynı sınıfı farklı veri tipleriyle kullanmamızı sağlar.
 // Örneğin GenericCache<User>, GenericCache<Product> gibi.
 // AMA User ve Product türlerinin Identifiable şartını karşılaması gerekir.

 // ÇALIŞMA MANTIĞI:
 // GenericCache oluşturulur -> save(item) çağrılır -> item.id anahtar olarak kullanılır
 // -> nesne Map'e kaydedilir -> getById(id) ile aranır
 // -> varsa T türünde nesne döner / yoksa null döner.

 // ÖNEMLİ:
 // <T> -> generic tür parametresi.
 // <T extends Identifiable> -> T için TÜR KISITLAMASI.
 // Map<String,T> -> String anahtar, T türünde değer saklar.
 // T? -> sonuç null OLABİLİR.
 // Cache -> verileri daha hızlı erişmek amacıyla geçici olarak saklayan yapı.
 // BU ÖRNEKTE CACHE BELLEK İÇİNDEDİR, uygulama kapanınca kalıcı olarak saklanmaz.
 */

import 'dart:async'; // dart:async: Dart'ın asenkron programlama kütüphanesi. scheduleMicrotask() gibi yapılar için kullanılır.

// EVENT LOOP: Dart'ın asenkron olayları hangi sırada işleyeceğini yöneten mekanizma.
// MICROTASK QUEUE: öncelikli görevlerin bulunduğu VIP kuyruk.
// EVENT QUEUE: normal asenkron olayların bulunduğu kuyruk.
// ÖNEMLİ: SENKRON KODLAR -> MICROTASK QUEUE -> EVENT QUEUE sırasıyla çalışır.

void main() async {
  // main(): programın başlangıç noktası. async: fonk. await kullanabilir. BU KODDA await KULLANILMAMIŞ.
  print(
    "1. Senkron başladı",
  ); // SENKRON: doğrudan çalışır. Konsola ilk yazdırılan metindir.

  scheduleMicrotask(() {
    // scheduleMicrotask(): fonksiyonu Microtask Queue'ya (VIP kuyruk) ekler. HEMEN ÇALIŞMAZ. Önce mevcut senkron kodlar tamamlanır.
    print(
      "2. Task oluştu(Vip kuyruk)",
    ); // ilk eklenen microtask olduğu için microtask'lar arasında ilk çalışır.
  });

  Future(() {
    // Future(): callback'i Event Queue'ya planlar. Microtask'lardan SONRA çalışır.
    print(
      "3. Standart Event Kuyruğu",
    ); // normal kuyruktaki görev. VIP kuyruk boşalmadan çalışmaz.
  });

  Future.microtask(() {
    // Future.microtask(): callback'i Microtask Queue'ya ekler. scheduleMicrotask() ile aynı önceliğe sahiptir, ancak Future nesnesi döndürür.
    print(
      "4. Future.microtask çalıştı",
    ); // ikinci eklenen microtask olduğu için ilk microtask'tan sonra çalışır.
  });

  print("5. Senkron kod tamamlandı"); // SENKRON işlem. Microtask'lar daha önce planlanmış olsa bile önce bu satır çalışır.
}

// ÇALIŞMA SIRASI:
// main() çağrılır -> 1 yazdırılır -> scheduleMicrotask VIP kuyruğa eklenir
// -> Future() normal kuyruğa eklenir -> Future.microtask VIP kuyruğa eklenir
// -> 5 yazdırılır -> senkron kod biter -> ilk microtask 2 yazdırılır
// -> ikinci microtask 4 yazdırılır -> normal Event Queue 3 yazdırılır.

// KONSOL ÇIKTISI:
// 1. Senkron başladı
// 5. Senkron kod tamamlandı
// 2. Task oluştu(Vip kuyruk)
// 4. Future.microtask çalıştı
// 3. Standart Event Kuyruğu

// ÖNEMLİ:
// print() içindeki 1,2,3,4,5 sayıları ÇALIŞMA SIRASINI BELİRLEMEZ.
// Önce senkron kodlar çalışır, ardından microtask kuyruğu boşaltılır.
// scheduleMicrotask() ve Future.microtask() AYNI KUYRUKTA çalışır.
// Future() ile oluşturulan callback normal Event Queue'da çalışır.
// scheduleMicrotask() void döndürür, Future.microtask() Future döndürür.
// Microtask kuyruğu sürekli yeni görevlerle doldurulursa normal Event Queue gecikebilir.
// async yazılması fonksiyon içindeki bütün satırların otomatik olarak kuyruğa alınacağı anlamına GELMEZ.
