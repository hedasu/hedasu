// -bu dosyada DefaultTabController, TabBar ve TabBarView kullanılarak 3 farklı ekran (Arayüz, Piyasalar, Transfer) arasında sekmeli geçiş yapısı anlatılıyor.-
// DefaultTabController: Sekmeli (Tab) yapıyı ekstra bir StatefulWidget ve TabController tanımlamaya gerek kalmadan otomatik olarak yöneten sarmalayıcı widget'tır.
// TabBar: AppBar'ın alt kısmında (bottom) yer alan ve kullanıcının tıklayarak sekme değiştirmesini sağlayan sekme başlıkları çubuğudur.
// TabBarView: Seçili sekmeye karşılık gelen ekran içeriğini gösteren ve parmakla sağa/sola kaydırma (swipe) hareketini destekleyen gövde widget'ıdır.

import 'package:flutter/material.dart'; // Flutter Material Design görsel bileşenlerini dahil eder.

// Oluşturduğumuz ekranlar (Başka dosyalardaki ekran sınıflarını bu dosyada kullanabilmek için import ediyoruz)
import 'screens/01_layout_screen.dart'; // 1. Sekme: Cüzdan özeti, hızlı aksiyonlar ve istatistik ekranı (LayoutStylingScreen).
import 'screens/02_market_list_screen.dart'; // 2. Sekme: Kripto varlıklar (GridView) ve son işlemler (ListView) ekranı (MarketsGridListScreen).
import 'screens/03_transfer_form_screen.dart'; // 3. Sekme: Para gönderme formu (BottomSheet) ve transfer geçmişi ekranı (TransferFormScreen).

void main() { // Uygulamanın başlangıç noktası.
  runApp(const DtmMAsterApp()); // Kök widget olarak DtmMAsterApp'i başlatır.
}

class DtmMAsterApp extends StatelessWidget { // Uygulama genel ayarlarını ve temasını barındıran durumsuz (Stateless) kök sınıf.
  const DtmMAsterApp({super.key}); // Sabit constructor.

  @override
  Widget build(BuildContext context) {
    return MaterialApp( // Material tasarım ve navigasyon altyapısını kurar.
      debugShowCheckedModeBanner: false, // Sağ üstteki DEBUG şeridini kaldırır.
      title: "DTM Flutter Sınıfı", // Uygulama başlığı.
      theme: ThemeData( // Uygulama genel tema ayarları.
        useMaterial3: true, // Material 3 tasarım dilini etkinleştirir.
        colorScheme: ColorScheme.fromSeed( // İndigo renginden (0xFF6366F1) uyumlu renk şeması üretir.
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light, // Açık tema modu.
        ),
      ),

      // Uygulamanın ilk açılacak ekranı
      home: const LiveCanvasScreen(), // Ana ekran olarak sekmeli yapıyı barındıran LiveCanvasScreen'i açar.
    );
  }
}

class LiveCanvasScreen extends StatelessWidget { // 3 ekranı sekmeler (Tab) halinde birleştiren ana ekran sınıfı.
  const LiveCanvasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController( // TabBar ile TabBarView arasındaki senkronizasyonu (hangi sekmenin aktif olduğunu) otomatik yönetir.
      length: 3, // ÖNEMLİ: Toplam sekme sayısı (3). TabBar içindeki tabs sayısı (3) ve TabBarView içindeki children sayısı (3) ile BİREBİR AYNI OLMAK ZORUNDADIR!
      child: Scaffold( // Sayfa iskeleti.
        backgroundColor: const Color(0xFFF8FAFC), // Açık gri/mavi sayfa arka plan rengi.

        appBar: AppBar( // Üst başlık çubuğu.
          title: const Text(
            "DTM Canlı Arayüz",
            style: TextStyle(
              fontWeight: FontWeight.bold, // Kalın yazı.
              fontSize: 18, // 18px yazı boyutu.
            ),
          ),
          centerTitle: true, // Başlığı ortalar.
          backgroundColor: Colors.white, // Beyaz AppBar arka planı.
          elevation: 0, // Gölgeyi kaldırır.

          actions: [ // AppBar sağ üst köşe aksiyon butonları.
            IconButton(
              icon: const Icon(
                Icons.notifications_active_outlined, // Bildirim zili ikonu.
              ),
              onPressed: () {}, // Tıklama olayı (boş fonksiyon).
            ),
          ],

          // Ekranlar arasında geçiş yapmak için AppBar'ın alt kısmına (bottom) TabBar yerleştiriyoruz
          bottom: const TabBar(
            tabs: [ // Sekme başlıkları listesi (Sırası aşağıdaki TabBarView çocuklarıyla eşleşir).
              Tab( // 0. İndeksli Sekme -> LayoutStylingScreen'i açar.
                icon: Icon(Icons.dashboard_outlined), // Gösterge paneli ikonu.
                text: 'Arayüz', // Sekme etiketi.
              ),
              Tab( // 1. İndeksli Sekme -> MarketsGridListScreen'i açar.
                icon: Icon(Icons.currency_bitcoin), // Bitcoin / Kripto ikonu.
                text: 'Piyasalar', // Sekme etiketi.
              ),
              Tab( // 2. İndeksli Sekme -> TransferFormScreen'i açar.
                icon: Icon(Icons.send_outlined), // Gönderim ikonu.
                text: 'Transfer', // Sekme etiketi.
              ),
            ],
          ),
        ),

        // Oluşturduğumuz ekranları bağlıyoruz
        body: const TabBarView( // Seçilen sekmeye göre ilgili ekranı gösteren ve yatay kaydırma (swipe) sağlayan görünüm.
          children: [
            LayoutStylingScreen(), // 0. Sekmenin ekranı (Arayüz).
            MarketsGridListScreen(), // 1. Sekmenin ekranı (Piyasalar).
            TransferFormScreen(), // 2. Sekmenin ekranı (Transfer).
          ],
        ),
      ),
    );
  }
}

// ÇALIŞMA MANTIĞI:
// Uygulama başlar -> LiveCanvasScreen içinde DefaultTabController(length: 3) kurulur -> AppBar'ın bottom alanında TabBar 3 sekmeyi çizer -> Gövdede (body) TabBarView 3 ekranı sırasıyla bağlar -> Kullanıcı 'Piyasalar' sekmesine tıklar veya ekranı yana kaydırır -> DefaultTabController indeksi 1 yapar -> TabBarView otomatik olarak MarketsGridListScreen ekranını gösterir.

// TABBAR : Sadece üstteki tıklanabilir sekme düğmelerini (ikon ve başlıkları) gösterir, ekran içeriğini tutmaz.
//  VS
// TABBARVIEW : Sekmelere karşılık gelen asıl sayfa içeriklerini (ekran widget'larını) tutar ve sekmeler değiştikçe ilgili ekranı animasyonlu olarak ekrana getirir.
