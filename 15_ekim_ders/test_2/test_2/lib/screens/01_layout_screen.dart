// -bu dosyada Flutter'ın temel yerleşim (Layout) widget'ları (Column, Row, Stack, Expanded, Container, Padding) ve setState() ile bakiye gizleme/gösterme etkileşimi anlatılıyor.-
// StatefulWidget: Ekranda bakiye görünürlüğü (isBalanceVisible) ve son işlem metni (_lastAction) kullanıcı tıklamalarıyla değiştiği için StatefulWidget kullanılır.
// SingleChildScrollView: İçerik ekran boyutunu aştığında (özellikle küçük ekranlarda veya yatay modda) sarı-siyah "Overflow" (taşma) hatası almamak için sayfayı kaydırılabilir (scrollable) yapar.
// Row & Column: Elemanları yatay (Row) ve dikey (Column) eksende dizmek için kullanılan temel yerleşim widget'larıdır.
// Expanded: Row veya Column içindeki mevcut boş alanı çocuk widget'lar arasında eşit veya orantılı olarak paylaştırır.
// Stack: Widget'ları üst üste (Z ekseninde, katmanlı olarak) yerleştirmek için kullanılır (Örn: Profil fotoğrafının üzerine online rozeti koymak).

import 'package:flutter/material.dart'; // Flutter Material görsel bileşenlerini dahil eder.

class LayoutStylingScreen extends StatefulWidget { // LayoutStylingScreen: 1. Sekmedeki (Arayüz) ana ekran sınıfı | StatefulWidget: Dinamik durum barındırır.
  const LayoutStylingScreen({super.key}); // Sabit yapıcı metot.

  @override
  State<LayoutStylingScreen>
      createState() => //işlemlerin otomatik çalışması için stat kullanırız | createState(): Bu widget'ın durumunu yönetecek State nesnesini oluşturur.
          _LayoutStylingScreenState();
}

class _LayoutStylingScreenState extends State<LayoutStylingScreen> { // _LayoutStylingScreenState: Değişkenleri ve arayüz çizimini yöneten State sınıfı.
  bool isBalanceVisible = true; // isBalanceVisible: Bakiyenin açık mı (true -> '₺ 2.450,00') yoksa gizli mi (false -> '₺ ••••••') olduğunu tutan durum değişkeni.
  String _lastAction = 'Hazır - Butonlara Tıklayabilirsiniz'; // _lastAction: Kullanıcının en son hangi butona bastığını ekranda gösteren durum metni.

  @override
  Widget build(BuildContext context) { // Her setState() çağrıldığında yeniden çalışarak ekranı güncelleyen metot.
    return SingleChildScrollView( // Tüm sayfa içeriğini dikeyde kaydırılabilir yapar.
      physics:
          const BouncingScrollPhysics(), //ekranı scroll etme özelliğini aktiflşşitrme | iOS tarzı yaylanma (esneklik) efektiyle kaydırma sağlar (ClampingScrollPhysics olsaydı Android tarzı sert duruş olurdu).
      padding: const EdgeInsets.only(bottom: 32), // Sayfanın en altına 32 piksellik boşluk bırakır, içerik alt kenara yapışmaz.
      child: Column( // Tüm ana bölümleri yukarıdan aşağıya (dikey) alt alta dizer.
        crossAxisAlignment: CrossAxisAlignment.start, // Alt elemanları yatay eksende (sol kenara) hizalar (center olsaydı ortalardı).
        children: [
          //Profil online rozeti; (Modüler kodlama için her bölüm ayrı bir yardımcı metot (_build...) olarak ayrılmıştır)
          _buildProfileHeader(),
          //cüzdan kartı (Bakiye göster/gizle kartı)
          _buildWalletCard(),
          //aksiyon butonları-sayfalar arsı geçiş (Para Gönder, İşlemler, Profil butonları)
          _buildQuickActions(),
          //İstatistik Bölümü (Expanded ile yan yana Gelir ve Gider kutuları)
          _buildFlexStatistics(),
          // notification bldirim banner (Alt kısımdaki mavi bilgilendirme kutusu)
          _buildNotificationBanner(),

          //Canlı durum bildirimi (Kullanıcı butonlara bastıkça değişen _lastAction metni)
          Center( // Metni yatayda ortalar.
            child: Padding(
              padding: const EdgeInsets.all(16.0), // Her yönden 16px iç boşluk.
              child: Text(
                'Son İşlem: $_lastAction', // $_lastAction: Tıklanan butona göre setState() ile güncellenen metin.
                style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B), // Gri-mavi metin rengi.
                    fontStyle: FontStyle.italic), // Eğik (italik) yazı stili.
              ),
            ),
          )
        ],
      ),
    );
  }

  // 1. BÖLÜM: Profil Başlığı (Stack ve Yuvarlak Container kullanımı)
  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8), // Sol: 20, Üst: 16, Sağ: 20, Alt: 8 piksel boşluk.
      child: Row( // Yatay dizilim.
        children: [
          Stack( // Elemanları üst üste bindirmek için kullanılır (Örn: Avatar + Online durumu noktası).
            clipBehavior: Clip.none, // Clip.none: Stack sınırlarının dışına taşan alt widget'ların kesilmesini (kırpılmasını) engeller.
            children: [
              Container( // Profil avatarını temsil eden yuvarlak kutu.
                  width: 56, // Genişlik 56px.
                  height: 56, // Yükseklik 56px.
                  decoration: BoxDecoration( // Kutunun görsel süslemesi (renk, şekil, çerçeve).
                    shape: BoxShape.circle, // Kutuyu tam daire yapar.
                    color: const Color(0x1F6366F1), // %12 opaklıkta (0x1F) açık indigo arka plan rengi.
                    border:
                        Border.all(color: const Color(0xFF6366F1), width: 2), // 2px kalınlığında indigo çerçeve.
                  ))
            ],
          )
        ],
      ),
    );
  }

  // 2. BÖLÜM: Cüzdan Kartı (Ternary Operator ? : ve setState ile Bakiye Gizleme/Gösterme)
  Widget _buildWalletCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12), // Dış boşluklar.
      child: Container( // Mavi/İndigo cüzdan kartı kutusu.
        width: double.infinity, // double.infinity: Bulunduğu alanın (yatayda) tamamını kaplamasını sağlar.
        padding: const EdgeInsets.all(20), // Kartın iç kenarlarından 20px boşluk.
        decoration: BoxDecoration(
          color: const Color(0xFF6366F1), // Ana indigo renk.
          borderRadius: BorderRadius.circular(20), // Köşeleri 20px yarıçapında yuvarlatır.
        ),
        child: Column( // Kartın içindeki satırları alt alta dizer.
          crossAxisAlignment: CrossAxisAlignment.start, // İçerikleri sola yaslar.
          children: [
            Row( // 'Toplam Bakiye' yazısı ile 'Göz İkonu'nu aynı satırda yan yana koyar.
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // spaceBetween: İlk elemanı en sola, son elemanı en sağa iter, aradaki boşluğu maksimum yapar.
              children: [
                const Text(
                  'Toplam Bakiye',
                  style: TextStyle(
                    color: Colors.white70, // %70 görünürlükte yarı saydam beyaz renk.
                    fontSize: 14,
                  ),
                ),
                IconButton( // Göz ikonlu buton (Bakiye görünürlüğünü değiştirir).
                  onPressed: () {
                    setState(() { // ÖNEMLİ: Değişikliklerin ekrana yansıması için setState() çağrılır!
                      isBalanceVisible = !isBalanceVisible; // ! (Değil operatörü): true ise false yapar, false ise true yapar (tersine çevirir / toggle).
                      _lastAction = 'Bakiye görünürlüğü değiştirildi'; // Son işlem durumunu günceller.
                    });
                  },
                  icon: Icon(
                    // Ternary Operator (Koşul ? Doğruysa : Yanlışsa): Bakiye görünürse açık göz, gizliyse üstü çizili göz ikonu gösterir.
                    isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8), // Dikeyde 8px boşluk bırakan görünmez kutu.
            Text(
              // isBalanceVisible true ise gerçek tutarı, false ise yıldızlı/noktalı gizli metni gösterir.
              isBalanceVisible ? '₺ 2.450,00' : '₺ ••••••',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Güncel Cüzdan Bakiyesi',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3. BÖLÜM: Hızlı Aksiyon Butonları (Row ve MainAxisAlignment.spaceAround kullanımı)
  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Row( // 3 aksiyon butonunu yan yana dizer.
        mainAxisAlignment: MainAxisAlignment.spaceAround, // spaceAround: Elemanların etrafına eşit boşluk bırakarak yatayda dengeli dağıtır.
        children: [
          Column( // 1. Buton Grubu: İkon üstte, 'Para Gönder' yazısı altta.
            children: [
              IconButton(
                onPressed: () {
                  setState(() { // Tıklandığında alt kısımdaki 'Son İşlem' metnini günceller.
                    _lastAction = 'Para Gönder butonuna tıklandı';
                  });
                },
                icon: const Icon(
                  Icons.send,
                  color: Color(0xFF6366F1),
                  size: 30,
                ),
              ),
              const Text('Para Gönder'),
            ],
          ),
          Column( // 2. Buton Grubu: İkon üstte, 'İşlemler' yazısı altta.
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _lastAction = 'İşlemler butonuna tıklandı';
                  });
                },
                icon: const Icon(
                  Icons.history,
                  color: Color(0xFF6366F1),
                  size: 30,
                ),
              ),
              const Text('İşlemler'),
            ],
          ),
          Column( // 3. Buton Grubu: İkon üstte, 'Profil' yazısı altta.
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _lastAction = 'Profil butonuna tıklandı';
                  });
                },
                icon: const Icon(
                  Icons.person,
                  color: Color(0xFF6366F1),
                  size: 30,
                ),
              ),
              const Text('Profil'),
            ],
          ),
        ],
      ),
    );
  }

  // 4. BÖLÜM: Esnek İstatistik Kartları (Row içinde Expanded ile ekranı %50 - %50 paylaşma)
  Widget _buildFlexStatistics() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'İstatistikler',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row( // Gelir ve Gider kartlarını yan yana koyar.
            children: [
              Expanded( // Expanded (1. Kutu): Satırdaki boş alanı diğer Expanded ile eşit (%50 - %50) paylaşır. (Expanded olmasaydı kutular sadece içindeki yazı kadar dar kalırdı veya taşma yapardı).
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7), // Açık yeşil arka plan (Gelir).
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.trending_up, // Yükseliş oku ikonu.
                        color: Colors.green,
                      ),
                      SizedBox(height: 12),
                      Text('Toplam Gelir'),
                      SizedBox(height: 8),
                      Text(
                        '₺ 5.000',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12), // İki kart arasındaki 12 piksellik yatay boşluk.
              Expanded( // Expanded (2. Kutu): Kalan diğer %50'lik yatay alanı kaplar.
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2), // Açık kırmızı/pembe arka plan (Gider).
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.trending_down, // Düşüş oku ikonu.
                        color: Colors.red,
                      ),
                      SizedBox(height: 12),
                      Text('Toplam Gider'),
                      SizedBox(height: 8),
                      Text(
                        '₺ 2.550',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 5. BÖLÜM: Bildirim Banner'ı (Row içinde uzun metinlerin taşmasını önlemek için Expanded kullanımı)
  Widget _buildNotificationBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFE0F2FE), // Açık mavi bilgi kutusu rengi.
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFBAE6FD), // Açık mavi kenarlık.
          ),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.notifications_active,
              color: Color(0xFF0284C7),
            ),
            SizedBox(width: 12),
            Expanded( // ÖNEMLİ: Row içindeki uzun bir Text widget'ı Expanded ile sarmalanmazsa sağ kenardan taşarak "Right Overflowed by X pixels" hatası verir! Expanded sayesinde metin kalan alana sığar ve gerekirse alt satıra geçer.
              child: Text(
                'Yeni bildirimleriniz var! Güncel işlemlerinizi kontrol edin.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF0369A1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ÇALIŞMA MANTIĞI:
// LayoutStylingScreen açılır -> _LayoutStylingScreenState içinde isBalanceVisible = true ve _lastAction başlangıç değerleriyle build() çalışır
// -> SingleChildScrollView içinde 5 ana bölüm (_buildProfileHeader, _buildWalletCard, _buildQuickActions, _buildFlexStatistics, _buildNotificationBanner) alt alta çizilir
// -> Kullanıcı göz ikonuna veya hızlı aksiyon butonlarından birine tıklar -> setState() tetiklenir -> isBalanceVisible veya _lastAction güncellenir -> build() yeniden çalışarak ekrandaki bakiye ve son işlem yazısını anında günceller.

// MAINAXISALIGNMENT (Ana Eksen Hizalaması) : Row'da YATAY, Column'da DİKEY eksendeki elemanların nasıl dağılacağını (spaceBetween, spaceAround, center) belirler.
//  VS
// CROSSAXISALIGNMENT (Çapraz Eksen Hizalaması) : Row'da DİKEY, Column'da YATAY eksendeki elemanların nasıl hizalanacağını (start, center, stretch) belirler.
