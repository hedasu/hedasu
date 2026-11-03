
//import 'package:flutter/material.dart'; // Flutter'ın Material Design widget'larını kullanmamızı sağlar. | kullanılan paketler pubspec.yaml da tanımlanır

// STATEFULWIDGET LIFECYCLE: Bir widget'ın oluşturulması -> güncellenmesi -> ağaçtan kaldırılması süreci.
// StatefulWidget: zaman içinde değişebilen durum (state) bilgisine sahip widget.
// State: widget'ın değişebilen verilerini ve yaşam döngüsü metotlarını yöneten yapı.

// 1. createState()
// StatefulWidget için State nesnesi oluşturur.
// GENELLİKLE widget ilk kez ağaca eklendiğinde çağrılır.

// 2. mounted == true
// State nesnesi widget ağacındaki bir elemana bağlanmıştır.
// mounted: State şu anda ağaçla ilişkili mi?
// ÖNEMLİ: mounted == true olması widget'ın ekranda görünür olduğu anlamına GELMEZ.

// 3. initState()
// State oluşturulduğunda BİR KEZ çalışır.
// Başlangıç işlemleri, controller oluşturma, ilk veri isteğini başlatma burada yapılabilir.
// ÖNEMLİ: initState() içinde Theme.of(context) gibi inherited dependency oluşturacak erişimler yapılmaz.

// 4. didChangeDependencies()
// initState() sonrasında ilk kez çağrılır.
// Bağımlı olduğumuz InheritedWidget değiştiğinde tekrar çalışabilir.
// Theme.of(context), MediaQuery.of(context) gibi bağımlılık oluşturan erişimler burada güvenle yapılabilir.
// HER widget değişiminde çalışmaz. Sadece ilgili bağımlılıklar değiştiğinde yeniden tetiklenebilir.

// 5. build(BuildContext context)
// UI'ı oluşturan Widget ağacını döndürür.
// İlk oluşturulmada ve gerekli yeniden oluşturmalarda çalışır.
// setState(), üst widget değişimleri veya bağımlılık değişimleri nedeniyle tekrar çağrılabilir.
// ÖNEMLİ: build() ÇOK KEZ ÇALIŞABİLİR.
// API isteğini doğrudan build() içinde sürekli yeniden başlatmak YANLIŞ BİR YAKLAŞIMDIR.
// build() yapmak APK çıkarmak DEĞİLDİR. Widget arayüzünü oluşturmak/güncellemektir.

// 6. didUpdateWidget(oldWidget)
// Aynı tür ve key'e sahip StatefulWidget, üst widget tarafından yeni yapılandırmayla güncellendiğinde çalışır.
// oldWidget: önceki widget yapılandırması.
// widget: güncel widget yapılandırması.
// ÖNEMLİ: Her setState() çağrısında çalışmak ZORUNDA DEĞİLDİR.

// 7. deactivate()
// State, widget ağacından çıkarıldığında çağrılır.
// Bazı durumlarda aynı State yeniden ağaca eklenebilir.
// Bu nedenle HER deactivate() çağrısından sonra dispose() çalışması zorunlu değildir.

// 8. dispose()
// State kalıcı olarak ağaçtan çıkarıldığında çalışır.
// Controller.dispose(), StreamSubscription.cancel() gibi temizlik işlemleri burada yapılır.
// ÖNEMLİ: dispose() sonrasında setState() ÇAĞRILMAZ.

// 9. mounted == false
// State artık widget ağacına bağlı değildir.
// dispose() sonrasında mounted false olur.
// ÖNEMLİ: await sonrası setState() kullanmadan önce mounted kontrolü yapılmalıdır.

// GENEL AKIŞ:
// createState() -> mounted=true -> initState()
// -> didChangeDependencies() -> build()
// -> güncelleme durumuna göre didUpdateWidget() / didChangeDependencies() / build()
// -> deactivate() -> dispose() -> mounted=false

// DİKKAT:
// Bu sıra ilk oluşturulma ve kalıcı kaldırılma için genel bir özettir.
// build(), didChangeDependencies(), didUpdateWidget() birden fazla kez çalışabilir.
// deactivate() sonrası State yeniden ağaca eklenebilir.

//  EK NOT

setState(() { // State içindeki bir verinin değiştiğini Flutter'a bildirir. Arayüzün yeniden oluşturulmasını planlar.
  counter++; // counter değişkenini 1 artırır.
});

// ÇALIŞMA MANTIĞI:
// Kullanıcı butona basar -> setState() çağrılır
// -> counter değişir -> Flutter yeniden build() planlar
// -> ekranda yeni değer gösterilir.

// ÖNEMLİ:
// setState() -> initState() metodunu TEKRAR ÇALIŞTIRMAZ.
// setState() -> yeni bir State nesnesi oluşturmaz.
// setState() -> mevcut State için yeni build() planlar.
// didUpdateWidget() -> üst widget'tan yeni yapılandırma geldiğinde çalışır.
// dispose() -> State kalıcı olarak kaldırıldığında temizlik yapar.
