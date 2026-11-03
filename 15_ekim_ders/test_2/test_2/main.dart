// -bu dosyada Flutter uygulamasının temel başlangıç yapısı (MaterialApp, ThemeData) ve Scaffold ile AppBar/Body kurulumu anlatılıyor.-
// MaterialApp: Uygulamanın genel tema, başlık, renk paleti ve sayfa yönlendirme (routing) ayarlarını tutan en dıştaki kök widget'tır.
// Scaffold: Bir ekranın görsel iskeletini (AppBar, Body, BottomNavigationBar, FloatingActionButton) oluşturan temel sayfa yapısıdır.
// ThemeData & ColorScheme.fromSeed: Tek bir ana renkten (seedColor) tüm uygulama için birbiriyle uyumlu Material 3 renk paleti üretir.

import 'package:flutter/material.dart'; // Flutter'ın Material Design görsel kütüphanesini projeye dahil eder.

void main(){ // main(): Dart programının ilk çalışmaya başladığı ana giriş noktasıdır | void: Geriye değer döndürmez.
    runApp(const DtmMAsterApp()); // runApp(): Verilen widget'ı (DtmMAsterApp) tüm ekranı kaplayacak şekilde kök widget olarak başlatır.
}

class DtmMAsterApp extends StatelessWidget { // DtmMAsterApp: Uygulamanın ana ayarlarını tutan sınıf | StatelessWidget: Durumu değişmeyen sabit widget.
    const DtmMAsterApp({super.key}); // const yapıcı metot: Performans için widget'ı derleme zamanında sabitler | super.key: Widget kimliğini üst sınıfa iletir.

    @override // Üst sınıftaki (StatelessWidget) build metodunu kendi tasarımımızla ezdiğimizi (yeniden tanımladığımızı) derleyiciye bildirir.
//  Widget @override bu yanlış kullanım hoca görelim diye verdi(alt alta iki @override) -> HATA NOTU: @override anotasyonu dönüş tipinden (Widget) ÖNCE ve yalnızca BİR KEZ yazılmalıdır.
    Widget build(BuildContext context) { // build(): Arayüzü çizen metot | BuildContext: Widget'ın ağaçtaki konumunu temsil eder.
        return MaterialApp( // MaterialApp: Material tasarım kurallarını ve navigasyon altyapısını sağlar.
            debugShowCheckedModeBanner:false, // Sağ üst köşedeki kırmızı "DEBUG" etiketini gizler (true olsaydı etiketi ekranda görürdük).
            title:"DTM Flutter Sınıfı", // Uygulamanın işletim sistemi görev yöneticisinde görünen başlığı.
            theme:ThemeData( // theme: Uygulamanın varsayılan görsel temasını yapılandırır.
                useMaterial3:true, // Google'ın modern Material 3 tasarım sistemini aktif eder.
                colorScheme:ColorScheme.fromSeed( // fromSeed(): Verilen tohum renkten (seedColor) açık/koyu tonları otomatik türetir.
                    seedColor: const Color(0xFF6366F1), // 0xFF6366F1: İndigo/mor tonunda özel HEX renk kodu (0xFF = %100 görünürlük/opaklık).
                    brightness:Brightness.light, // Uygulamanın aydınlık (light) temada çalışacağını belirtir (Brightness.dark olsaydı karanlık tema olurdu).
                ),
            ),

            home: const LiveCanvasScreen(),//ana ekranın canlı çalıştığıı belirtiyoruz | home: Uygulama açıldığında ilk gösterilecek ekran widget'ı.
        );            
    }
}

class LiveCanvasScreen extends StatelessWidget{ // LiveCanvasScreen: Ana sayfa görünümünü oluşturan durumsuz (Stateless) ekran sınıfı.
  const LiveCanvasScreen({super.key}); // Sabit (const) yapıcı metot.

  @override
  Widget build(BuildContext context){
    return Scaffold( // Scaffold: Beyaz bir tuval gibi ekranın üst bar (appBar) ve gövde (body) bölümlerini yerleştirir.
      backgroundColor:const Color(0xFFF8FaFC), // Sayfa arka plan rengini çok açık gri/mavi (#F8FAFC) yapar.
      appBar:AppBar( // appBar: Ekranın en üstünde yer alan başlık ve aksiyon çubuğu.
        title:const Text( // title: AppBar üzerinde gösterilecek başlık widget'ı.
          "DTM Canlı Arayüz", // Başlık metni.
          style:TextStyle(fontWeight:FontWeight.bold,fontSize:18), // Kalın (bold) ve 18 piksel boyutunda yazı stili.
        ),
        centerTitle:true, // Başlığı Android ve iOS fark etmeksizin tam ortaya hizalar (false olsaydı Android'de sola yaslanırdı).
        backgroundColor:Colors.white, // AppBar arka plan rengini beyaz yapar.
        elevation:0, // AppBar altındaki gölge derinliğini sıfırlar (düz/flat görünüm sağlar).
        actions:[ // actions: AppBar'ın sağ tarafına dizilecek etkileşimli butonlar listesi.
          IconButton( // Tıklanabilir ikon butonu.
            icon:const Icon(Icons.notifications_active_outlined), // Zil / bildirim ikonu.
            onPressed:(){}, // onPressed: Butona basıldığında çalışacak anonim fonksiyon (şu an içi boş {}, tıklanabilir ama işlem yapmaz | null verilseydi buton pasif/tıklanamaz olurdu).
          ),
        ],
        ),
        body:const Center( // body: AppBar dışındaki ana ekran alanı | Center: İçindeki elemanı yatay ve dikey olarak tam ortaya yerleştirir.
          child:Text("Buraya Canlı Arayüz Gelecek"), // Ekranın ortasında gösterilen sabit metin.
        )

      
    );
  }

}

// ÇALIŞMA MANTIĞI:
// main() çalışır -> runApp() ile DtmMAsterApp başlatılır -> MaterialApp tema ve renk ayarlarını (ColorScheme.fromSeed) yükler -> home parametresindeki LiveCanvasScreen() ekrana çizilir -> Scaffold içinde üstte AppBar (başlık + bildirim ikonu), ortada ise Center içinde Text gösterilir.

// MATERIALAPP : Uygulamanın tamamını kapsayan, tema, dil, navigasyon (sayfalar arası geçiş) ayarlarını tutan en üst çatı widget'tır (Uygulamada 1 tane olur).
//  VS
// SCAFFOLD : Uygulamanın içindeki tek bir ekranın/sayfanın görsel düzenini (AppBar, Body, Drawer, BottomNavigationBar) kuran sayfa iskeletidir (Her ekran için ayrı kullanılabilir).
