/*
-bu kod bloğunda birden fazla işlemi aynı anda başlatmak ve beklemek anlatılıyor.-
Future<void> fetchDashboardData() async { -async:fonk.un asenkron işlem içerebileceğini belirtir . await kullanımına izin verir
  try {
    final result = await Future.wait([ -wait le kullanılınca bu üç onk. aynı anda başlar ve hepsinin tamamlanması beklenir. (await fonk1()/n await fonk2()/n await fonk3() şeklinde wait kullanmadan oluşturulaydı sıra ile başlar biter )-
                                       -future.wai değerleriişlem tamamlanmasına göre değil,lsteye yazdığımız sıraya göre tutar ['result1','result2','result3'] 
      fetchUserProfile(),             -buradaki await ise Future.wait() tarafından oluşturulan Future'un onucunun tamamlanmasını bekler-
      fetchAccountBalance(),           - final değişkene bir kez değer atanabbileceğini belirtir.-
      fetchNotification(),             -result: başarılı işlemlerin sonuçlarının toplandığı br List olur
    ], eagerError: true); -HATA YÖNETİMİ. buu üç işlemden biri hata verirse 3ünün de bitmesini beklemeden hata verir.DİĞER İSTEKLER OTOMTİK İPTAL EDİLMEZ.ARKA PLANDA ÇALIŞMAYA DEVAM EDEBİLLİR            
  try{
    print("Tüm veriler geldi $result");                -try: İşlemleri gerçekleştirmeyi dene./catch: İşlem hata verirse hatayı yakala./e: Yakalanan hata nesnesi./$e: Hata bilgisini yazının içine ekler.
  } catch (e) {
    print("isteklerden biribaşarısız oldu $e");
  }
}  - fetchDashboardData çağrılır -> üç async işlem başlatılıt -> Future.wait() sonuçları bekler -> başarılı ise tüm sonuçları yazdır / hata ise catch bloguna geç 
*/

//Future<veri tipi>: Tek bir kere veri çekeceğimniz zaman kullanılır ya hata ya da değer dönüp bitiriirz. SONUCU HEMEN DEĞİL,GELECEKTE TAMAMLANACAK BİR İŞLEMİ TEMSİL EDER
//void:işlem tamamlandığında geriye kullanılabilir bir değer döndürmez.bunu tanımlar
//Stream : Bir boru hattı şeklinde çalışır(pipe), zaman içinde 1,10,100 ya da sonsuz sayıda veri akışı sağlanabilir
//Borsa fiyatları,gps konum güncelleme, firebase canlı dinleme

import 'dart:async';

void main() {
  //controller oluşturma : veri kkaynnağı oluşturma
  final controller = StreamController<int>(); // StreamControllr: veri akışını yönetmemizi sağlayn sınıf <int> : akışa tam sayı verileri gönderir  final controller : Oluşturduğumuz nesneyi controller değişkeninde tutuyoruz. Bu değişkene başka bir nesne atayamayız.
  // bu akış single-subscription (tek bboonelikli akış) | bu akıı iki farklı yerde kullanmak için -> broadcastStream.listen();
  //dinbleyici oluşturma

  /*  final subscription = controller.stream.listen( //controller.stream akışın kendisi .listen(): akıştak oolayları dinle
    (data) => print("yeni veri : $data"), // yeni veri geldiğinde ekran yazdır
    onError: (err) => print("Hata oluştu : $err"), // akş hata olayı gönderirse çalışır
    onDone: () => print("Stream tamamlandı"), // akış tamamlandığında çalışır  
    // AYRICA listen(),StreamSubscription nesnesi dödürür.bu nesne sayesinde dinlemeyi duraklatabilit veya iptal edebiliriz
  ); */

  controller.sink.add(
    10,
  ); // sink: controllera veri gönderebildiğimiz giriş noktası
  controller.sink.add(20); // controller : StreamControler nesnesi
  controller.sink.add(30); // add() : akışa yeni bir veri ekler(ekrana yazdırmaz yazdırma işni listen() yapar)

  // stream : controller ve listener arası bağ
  final broadcastStream = controller.stream.asBroadcastStream(); //asBroadcastStream() sayesinde aynı akışa birden fazla dinleyici bağlyabiliyoruz
  broadcastStream.listen((d) => print("UI Ekranı : $d"));
  broadcastStream.listen((d) => print("Analitik Servis Ekranı : $d"));

  controller.close(); // akışa yeni veri göneimini sonlandırır.
}

// FUTURE : tek bir asenkron sonuç,bir işlem tamalnaır,tek bir sonuç gelir
//  VS
// STREAM : zaman içinde çok sayıda olay,veriler zaman içinde birer birer gelebilir
