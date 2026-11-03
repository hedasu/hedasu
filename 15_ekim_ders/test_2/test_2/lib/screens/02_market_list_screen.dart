// -bu dosyada LayoutBuilder ile duyarlı (responsive) tasarım, GridView.builder ile ızgara görünümü ve ListView.separated ile işlem listesi oluşturma anlatılıyor.-
// LayoutBuilder: Üst widget'tan gelen ekran/alan genişliği kısıtlamalarını (constraints.maxWidth) öğrenerek ekran boyutuna göre (telefon vs tablet) sütun sayısını dinamik ayarlamamızı sağlar.
// GridView.builder: Verileri satır ve sütunlardan oluşan bir ızgara (grid) şeklinde ekrana çizer.
// ListView.separated: Verileri alt alta liste şeklinde çizerken her iki eleman arasına otomatik bir ayırıcı widget (boşluk veya çizgi) ekler.
// shrinkWrap: true & NeverScrollableScrollPhysics(): Bir SingleChildScrollView (ana kaydırıcı) içinde başka bir kaydırılabilir liste (GridView/ListView) kullanıldığında çakışmayı önlemek için içteki listelerin kendi kaydırmasını kapatıp sadece içerikleri kadar yer kaplamasını sağlayan kritik ikilidir.

import 'package:flutter/material.dart'; // Flutter Material bileşenlerini dahil eder.
import '../models/asset_model.dart'; // Kripto varlık modelini (Asset) dahil eder.
import '../models/transation_model.dart'; // İşlem geçmişi modelini (TransactionItem) dahil eder.

class MarketsGridListScreen extends StatelessWidget { // MarketsGridListScreen: 2. Sekmedeki (Piyasalar) ekran sınıfı | Veriler sabit olduğu için StatelessWidget kullanılmıştır.
  const MarketsGridListScreen({super.key});

  // static const List<Asset>: Sınıfa ait, derleme zamanında sabitlenmiş 3 elemanlı kripto para listesi.
  static const List<Asset> assets = [
    Asset(
      symbol: 'BTC', // Sembol
      name: 'Bitcoin', // İsim
      price: 67420.00, // Güncel fiyat ($)
      change24h: 4.20, // Pozitif değişim (+%4.20 -> Yeşil yazılacak)
      balance: 0.4, // Cüzdandaki miktar
    ),
    Asset(
      symbol: 'ETH',
      name: 'Ethereum',
      price: 3500,
      change24h: -1.80, // Negatif değişim (-%1.80 -> Kırmızı yazılacak)
      balance: 4.20,
    ),
    Asset(
      symbol: 'SOL',
      name: 'Solana',
      price: 200.00,
      change24h: 0.5, // Pozitif değişim (+%0.50 -> Yeşil yazılacak)
      balance: 85.00,
    ),
  ];

  // static const List<TransactionItem>: Sınıfa ait, sabit işlem geçmişi listesi.
  static const List<TransactionItem> transactions = [
    TransactionItem(
        id: 'tx_1',
        title: 'Apple Store',
        category: 'Teknoloji',
        date: 'bugün 14:20',
        amount: 64500,
        isExpense: true, // Gider (true -> Kırmızı ikon ve -₺64500.00)
        icon: Icons.laptop_mac),
    TransactionItem(
        id: 'tx_2',
        title: 'Kodusta Danışmanlık Hakediş',
        category: 'Kurumsal Gelir',
        date: 'Dün 09:00',
        amount: 125000.00,
        isExpense: false, // Gelir (false -> Yeşil ikon ve +₺125000.00)
        icon: Icons.account_balance),
    TransactionItem(
        id: 'tx_1',
        title: 'Apple Store',
        category: 'Teknoloji',
        date: 'bugün 14:20',
        amount: 64500,
        isExpense: true,
        icon: Icons.laptop_mac),
    TransactionItem(
        id: 'tx_1',
        title: 'Apple Store',
        category: 'Teknoloji',
        date: 'bugün 14:20',
        amount: 64500,
        isExpense: true,
        icon: Icons.laptop_mac),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Hem GridView'un hem de ListView'un birlikte tek bir sayfa olarak kaydırılmasını sağlar.
      physics: const BouncingScrollPhysics(), // Yaylanma efektli kaydırma fiziği.
      padding: const EdgeInsets.all(20), // Sayfanın her kenarından 20px boşluk.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Başlıkları sola hizalar.
        children: [
          // Kripto varlıklar başlığı
          const Text(
            'Kripto Varlıklarım',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // Kripto varlıklar (GridView)
          _buildAssetsGrid(),

          const SizedBox(height: 30),

          // Son işlemler başlığı
          const Text(
            'Son İşlemler',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // Son işlemler (ListView)
          _buildTransactionsList(),
        ],
      ),
    );
  }

  // Kripto varlıkların grid (ızgara) görünümü
  Widget _buildAssetsGrid() {
    return LayoutBuilder( // LayoutBuilder: İçinde bulunduğu alanın genişliğini (constraints.maxWidth) ölçer.
      builder: (context, constraints) {
        return GridView.builder( // Elemanları indeks sırasına göre ızgara şeklinde oluşturan kurucu.
          shrinkWrap: true, // ÖNEMLİ: GridView normalde sonsuz yüksekliğe yayılmak ister. Column/SingleChildScrollView içinde olduğu için sadece içindeki elemanların toplam boyu kadar yer kaplamasını (büzülmesini) sağlar. (Kullanılmasaydı "Vertical viewport was given unbounded height" hatası verirdi).
          physics: const NeverScrollableScrollPhysics(), // GridView'un kendi iç kaydırmasını kapatır; böylece kaydırma işini en dıştaki SingleChildScrollView üstlenir.
          itemCount: assets.length, // Toplam çizilecek kart sayısı (assets listesinin uzunluğu = 3).
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( // Sütun sayısına göre ızgara düzenini belirleyen delege.
            crossAxisCount: constraints.maxWidth >= 600 ? 3 : 2, // RESPONSIVE TASARIM: Ekran genişliği 600px ve üzeriyse (tablet/yatay ekran) yan yana 3 kart, değilse (telefon) yan yana 2 kart diz!
            crossAxisSpacing: 12, // Yan yana duran kartlar arasındaki yatay boşluk (12px).
            mainAxisSpacing: 12, // Alt alta duran kartlar arasındaki dikey boşluk (12px).
            mainAxisExtent: 185, // Her bir kartın sabit dikey yüksekliği (185px).
          ),
          itemBuilder: (context, index) { // 0'dan başlayarak her indeks için sırayla çalışır (index: 0, 1, 2).
            return _buildAssetCard(assets[index]); // İlgili indeksteki Asset nesnesini kart tasarımına gönderir.
          },
        );
      },
    );
  }

  // Kripto varlık kartı (Her bir Asset nesnesi için çizilen kutu)
  Widget _buildAssetCard(Asset asset) {
    bool isPositive = asset.change24h >= 0; // 24 saatlik değişim 0 veya daha büyükse true (yükseliş), küçükse false (düşüş).

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0), // Açık gri çerçeve.
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kripto simgesi (Baş harfi gösteren yuvarlak avatar)
          CircleAvatar(
            backgroundColor: const Color(0xFFE0E7FF), // Açık mor/indigo arka plan.
            child: Text(
              asset.symbol.substring(0, 1), // substring(0, 1): Sembolün sadece ilk harfini alır (Örn: 'BTC' -> 'B', 'ETH' -> 'E').
              style: const TextStyle(
                color: Color(0xFF6366F1),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Kripto adı
          Text(
            asset.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1, // İsim çok uzunsa en fazla 1 satırda göster.
            overflow: TextOverflow.ellipsis, // Sığmayan kısmı '...' (üç nokta) ile kısalt, taşma hatasını önle!
          ),

          const SizedBox(height: 5),

          // Kripto fiyatı
          Text(
            '\$${asset.price.toStringAsFixed(2)}', // \$: Dolar işaretini metin olarak basar (kaçış karakteri) | toStringAsFixed(2): Sayıyı virgülden sonra 2 basamakla sınırlar (67420.00).
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 5),

          // 24 saatlik değişim
          Text(
            '${isPositive ? '+' : ''}${asset.change24h.toStringAsFixed(2)}%', // Pozitifse başına '+' ekler (negatif sayının kendi '-' işareti zaten vardır).
            style: TextStyle(
              color: isPositive ? Colors.green : Colors.red, // Yükselişse yeşil, düşüşse kırmızı renk.
              fontWeight: FontWeight.bold,
            ),
          ),

          const Spacer(), // Spacer(): Üstteki elemanlarla alttaki bakiye yazısı arasındaki tüm boşluğu esnek şekilde doldurarak bakiye yazısını kartın en altına iter.

          // Kripto bakiyesi
          Text(
            'Bakiye: ${asset.balance} ${asset.symbol}',
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Son işlemler listesi
  Widget _buildTransactionsList() {
    return ListView.separated( // Elemanların arasına ayırıcı (separator) koyarak liste oluşturan widget.
      shrinkWrap: true, // SingleChildScrollView içinde olduğu için sadece elemanları kadar dikey alan kaplar.
      physics: const NeverScrollableScrollPhysics(), // Kendi kaydırmasını devre dışı bırakır.
      itemCount: transactions.length, // İşlem sayısı kadar satır oluşturur.
      separatorBuilder: (context, index) { // Her iki işlem kartının arasına 10 piksellik dikey boşluk ekler.
        return const SizedBox(height: 10);
      },
      itemBuilder: (context, index) { // Sıradaki işlemi alıp kart görünümüne (_buildTransactionCard) dönüştürür.
        return _buildTransactionCard(transactions[index]);
      },
    );
  }

  // İşlem kartı (Her bir TransactionItem için çizilen satır)
  Widget _buildTransactionCard(TransactionItem transaction) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
      ),
      child: Row( // İkon (sol), Başlık/Kategori (orta) ve Tutar (sağ) bilgilerini yan yana dizer.
        children: [
          // İşlem ikonu kutusu
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              // Giderse açık kırmızı (0xFFFEE2E2), gelirse açık yeşil (0xFFDCFCE7) arka plan.
              color: transaction.isExpense
                  ? const Color(0xFFFEE2E2)
                  : const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              transaction.icon,
              color: transaction.isExpense
                  ? Colors.red
                  : Colors.green, // Giderse kırmızı, gelirse yeşil ikon.
            ),
          ),

          const SizedBox(width: 12),

          // İşlem bilgileri (Başlık ve Kategori • Tarih)
          Expanded( // Expanded: Orta kısmın kalan tüm yatay alanı kaplamasını ve tutar yazısını en sağa itmesini sağlar.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis, // Uzun başlıkları '...' ile keser.
                ),

                const SizedBox(height: 4),

                Text(
                  '${transaction.category} • ${transaction.date}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // İşlem tutarı
          Text(
            '${transaction.isExpense ? '-' : '+'}₺${transaction.amount.toStringAsFixed(2)}', // Giderse '-₺...', gelirse '+₺...' yazar.
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: transaction.isExpense
                  ? Colors.red
                  : Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}

// ÇALIŞMA MANTIĞI:
// MarketsGridListScreen çizilir -> SingleChildScrollView tüm sayfayı sarar -> _buildAssetsGrid() içinde LayoutBuilder ekran genişliğini kontrol eder (>=600 ise 3 sütun, değilse 2 sütun) -> GridView.builder ile assets listesindeki kripto varlıklar kartlara dönüştürülür -> Altında _buildTransactionsList() ile ListView.separated çalışır -> transactions listesindeki her işlem aralarında 10px boşlukla alt alta sıralanır.

// GRIDVIEW.BUILDER : Verileri hem satır hem sütun (2 boyutlu ızgara/kartlar) halinde yan yana ve alt alta dizmek için kullanılır.
//  VS
// LISTVIEW.SEPARATED : Verileri tek sütunda (1 boyutlu dikey liste) alt alta dizmek ve her eleman arasına otomatik ayırıcı (boşluk/çizgi) koymak için kullanılır.
