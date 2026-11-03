// -bu dosyada kazanılan ve hedeflenen rozetlerin kullanıcıya gösterildiği ana ekran (BadgeView) ve ListenableBuilder ile reaktif arayüz güncellemesi anlatılıyor.-
// ListenableBuilder : Bir `Listenable` (örneğin `ChangeNotifier`) nesnesini dinleyen ve o nesnede `notifyListeners()` çağrıldığında SADECE kendi `builder` bloğu içindeki widget'ları yeniden çizen performans dostu widget'tır.
// SingleChildScrollView : İçindeki içerik ekran boyunu aştığında sayfanın dikeyde kaydırılabilmesini (scroll) sağlayan kapsayıcıdır.
// ListView.separated : Liste elemanlarını ve aralarındaki boşluk/ayırıcı widget'ları (`separatorBuilder`) dinamik olarak oluşturan liste bileşenidir.

import 'package:flutter/material.dart'; // Flutter Material görsel bileşenleri.
import '../controller/badge_controller.dart'; // Rozet durumlarını sağlayan BadgeController sınıfı.
import '../widgets/badge_card.dart'; // Tek bir rozet kartını çizen alt bileşen (modüler yapı).
import '../widgets/badge_summary_header.dart'; // Üstteki "Rozet Odası" genel ilerleme özet kartı.

/// Kazanılan ve hedeflenen rozetlerin görüntülendiği ana görünüm (View).
/// Kırmızı çizgiler uyarınca build metodu kısa tutulmuş, alt bileşenlere delege edilmiştir.
class BadgeView extends StatelessWidget { // StatelessWidget : Durumu kendi içinde (setState ile) değil, dışarıdan aldığı BadgeController ve ListenableBuilder ile yönettiği için StatelessWidget'tır.
  const BadgeView({
    super.key, // Widget kimlik anahtarı.
    required this.controller, // Bu ekranın dinleyeceği BadgeController nesnesi.
  });

  final BadgeController controller; // final : Dışarıdan (MainNavigationShell'den) enjekte edilen controller referansı.

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder( // ListenableBuilder : Sayfa düzeyinde setState kullanmak yerine controller'ı dinleyerek reaktif güncelleme yapar.
      listenable: controller, // listenable : Hangi nesnenin dinleneceğini belirtir (`controller` içinde `notifyListeners()` çağrılınca burası tetiklenir).
      builder: (context, _) { // builder : Controller her bildirim gönderdiğinde yeniden çalışan çizim fonksiyonu | `_` : değişmeyen alt widget (child) parametresi kullanılmadığı için `_` ile geçilir.
        final badges = controller.badges; // Controller'dan o anki güncel rozet listesini alır.

        return SingleChildScrollView( // Tüm sayfanın aşağı-yukarı kaydırılabilmesini sağlar.
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Kenarlardan yatayda 16, dikeyde 12 piksel iç boşluk bırakır.
          child: Column( // Column : Özet kartını, başlığı ve rozet listesini alt alta (dikeyde) dizer.
            crossAxisAlignment: CrossAxisAlignment.stretch, // CrossAxisAlignment.stretch : Alt elemanları yatay eksende ekran genişliğince (baştan sona) genişletir.
            children: [
              BadgeSummaryHeader( // 1. Alt Bileşen : Kazanılan rozet sayısını ve yüzdesini gösteren üst özet kartı.
                unlockedCount: controller.unlockedCount, // Kazanılan rozet adedi.
                totalCount: controller.totalCount, // Toplam rozet adedi.
                ratio: controller.unlockRatio, // 0.0 - 1.0 arası genel başarı oranı.
              ),
              const SizedBox(height: 20), // Kart ile başlık arasına 20 piksel dikey boşluk.
              const Text(
                'Tüm Başarılar', // Liste alt başlığı.
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700, // Kalın (Bold) yazı.
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10), // Başlık ile liste arasına 10 piksel dikey boşluk.
              ListView.separated( // ListView.separated : Rozet kartlarını aralarına eşit boşluk koyarak alt alta çizer.
                shrinkWrap: true, // ÖNEMLİ: SingleChildScrollView (Column) içinde ListView kullanıldığında sonsuz yükseklik hatası almamak için ListView'a "sadece elemanlarının toplam boyutu kadar yer kapla" der.
                physics: const NeverScrollableScrollPhysics(), // ÖNEMLİ: İçerideki ListView'ın kendi kaydırmasını kapatır; böylece tüm sayfa dıştaki SingleChildScrollView ile tek parça halinde kayar (çift scroll çakışmasını önler).
                itemCount: badges.length, // itemCount : Çizilecek toplam rozet sayısı (5).
                separatorBuilder: (context, index) => const SizedBox(height: 10), // separatorBuilder : Her iki rozet kartının arasına 10 piksellik dikey boşluk ekler.
                itemBuilder: (context, index) => BadgeCard(badge: badges[index]), // itemBuilder : Sıradaki (index) BadgeItem verisini alıp BadgeCard widget'ına dönüştürür.
              ),
            ],
          ),
        );
      },
    );
  }
}

// ÇALIŞMA MANTIĞI: BadgeController.notifyListeners() çalışır -> ListenableBuilder bunu yakalar -> builder fonksiyonu tekrar çalışır -> BadgeSummaryHeader ve BadgeCard listesi yeni rozet verileriyle ekranda güncellenir.

// LISTENABLEBUILDER : Sadece sarmaladığı builder bloğunu yeniden çizer, StatelessWidget içinde bile temiz ve modüler reaktif güncelleme sağlar.
//  VS
// SETSTATE() : Çağrıldığı StatefulWidget'ın tamamını (tüm build metodunu) yeniden çalıştırır ve iş mantığının UI dosyasına karışmasına yol açabilir.
