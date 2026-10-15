/*
Future<void> fetchDashboardData() async {
  try {
    final result = await Future.wait([
      fetchUserProfile(),
      fetchAccountBalance(),
      fetchNotification(),
    ], eagerError: true);

    print("Tüm veriler geldi $result");
  } catch (e) {
    print("isteklerden biribaşarısız oldu $e");
  }
}
*/

//Future : Tek bir kere veri çekeceğimniz zaman kullanılır ya hata ya da değer dönüp bitiriirz.

//Stream : Bir boru hattı şeklinde çalışır(pipe), zaman içinde 1,10,100 ya da sonsuz sayıda veri akışı sağlanabilir
//Borsa fiyatları,gps konum güncelleme, firebase canlı dinleme

import 'dart:async';

void main() {
  //controller oluşturma
  final controller = StreamController<int>();

  //dinbleyici oluşturma

  /*  final subscription = controller.stream.listen(
    (data) => print("yeni veri : $data"),
    onError: (err) => print("Hata oluştu : $err"),
    onDone: () => print("Stream tamamlandı"),
  ); */

  controller.sink.add(10);
  controller.sink.add(20);
  controller.sink.add(30);

  final broadcastStream = controller.stream.asBroadcastStream();
  broadcastStream.listen((d) => print("UI Ekranı : $d"));
  broadcastStream.listen((d) => print("Analitik Servis Ekranı : $d"));

  controller.close();
}
