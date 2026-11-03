// -bu dosyada showModalBottomSheet ile alttan açılır pencere, Form & TextFormField ile veri doğrulama (validation), TextEditingController ve setState() ile canlı para transferi işlemi anlatılıyor.-
// TextEditingController: Kullanıcının metin kutularına (TextFormField) yazdığı yazıları okumak, değiştirmek veya temizlemek için kullanılan kontrolcü nesnedir.
// GlobalKey<FormState>: Form widget'ının durumuna dışarıdan erişip tüm input'ların kurallara uyup uymadığını tek seferde kontrol etmemizi (formKey.currentState!.validate()) sağlayan benzersiz anahtardır.
// showModalBottomSheet: Ekranın altından yukarı doğru kayarak açılan modern diyalog/form penceresidir.
// dispose(): Kullanımı biten controller nesnelerini bellekten (RAM) temizleyerek bellek sızıntısını (memory leak) önler.

import 'package:flutter/material.dart'; // Flutter Material bileşenlerini dahil eder.
import '../models/transation_model.dart'; // İşlem geçmişi veri modelini (TransactionItem) dahil eder.

class TransferFormScreen extends StatefulWidget { // TransferFormScreen: 3. Sekmedeki (Transfer) ekranı | Bakiye azaldığı ve geçmiş listesine yeni işlem eklendiği için StatefulWidget'tır.
  const TransferFormScreen({super.key});

  @override
  State<TransferFormScreen> createState() => TransferFormScreenState(); // Durum nesnesini oluşturur.
}

class TransferFormScreenState extends State<TransferFormScreen> {
  double _balance = 148950.00; // _balance: Kullanıcının başlangıçtaki kullanılabilir bakiyesi (Transfer yapıldıkça azalacağı için final DEĞİLDİR).

  // _history: Yapılan transferlerin tutulduğu dinamik liste.
  // ÖNEMLİ: Liste değişkeni 'final' olarak tanımlanmıştır; yani _history'ye bambaşka bir liste atanamaz AMA .insert() veya .add() ile içine yeni eleman EKLENEBİLİR!
  final List<TransactionItem> _history = [
    const TransactionItem(
      id: 'tx_init_1',
      title: 'Ahmet Yılmaz',
      category: 'Hızlı Transfer',
      date: 'bugün 11.30',
      amount: 1500.00,
      isExpense: true,
      icon: Icons.send_rounded,
    ),
    const TransactionItem(
      id: 'tx_init_2',
      title: 'Ahmet Yılmaz',
      category: 'Hızlı Transfer',
      date: 'bugün 11.30',
      amount: 1500.00,
      isExpense: true,
      icon: Icons.send_rounded,
    ),
  ];

  // Transfer formunu alttan açılır pencere (Modal Bottom Sheet) olarak açan metot
  void _openTransferModel() {
    final TextEditingController nameController = TextEditingController(); // Alıcı adı input'unu okuyan kontrolcü.
    final TextEditingController amountController = TextEditingController(); // Transfer tutarı input'unu okuyan kontrolcü.
    final formKey = GlobalKey<FormState>(); // Formun doğrulama (validate) durumunu yöneten anahtar.

    showModalBottomSheet<void>( // Ekranın altından yukarı doğru açılan pencereyi başlatır ve bir Future döndürür.
      context: context,
      isScrollControlled: true, // ÖNEMLİ: true yapıldığında pencerenin tam boyuta kadar uzamasına izin verir ve klavye açıldığında pencerenin yukarı kaymasını sağlar.
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder( // Pencerenin sadece üst köşelerini (top) 24px yuvarlatır.
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) { // BottomSheet içindeki arayüzü çizen fonksiyon.
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            24,
            20,
            // KRİTİK NOKTA: MediaQuery.of(context).viewInsets.bottom ekran klavyesinin yüksekliğini verir.
            // Klavye açıldığında formun klavyenin altında kalmaması için alt boşluğa klavye yüksekliği + 24px eklenir!
            MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView( // Küçük ekranlarda klavye açıldığında formun kaydırılabilmesini sağlar.
            child: Form( // İçindeki tüm TextFormField'ları tek bir grup olarak yöneten sarmalayıcı widget.
              key: formKey, // Form anahtarını bağlıyoruz.
              child: Column(
                mainAxisSize: MainAxisSize.min, // MainAxisSize.min: Column'un tüm ekranı değil, sadece içindeki elemanlar kadar dikey yer kaplamasını sağlar.
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Para Transferi',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Transfer bilgilerini giriniz.',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 1. INPUT: Alıcı adı
                  TextFormField( // Doğrulama (validator) destekli metin giriş alanı.
                    controller: nameController, // Yazılan metni nameController içine kaydeder.
                    decoration: InputDecoration( // Input kutusunun görsel tasarımı.
                      labelText: 'Alıcı Adı Soyadı', // Üst bilgi etiketi.
                      prefixIcon: const Icon(Icons.person), // Sol baştaki kişi ikonu.
                      border: OutlineInputBorder( // Kutunun etrafına çerçeve çizer.
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) { // formKey.currentState!.validate() çağrıldığında otomatik çalışan kontrol fonksiyonu.
                      // value.trim(): Metnin başındaki ve sonundaki boşlukları siler (Sadece boşluk tuşuna basılmasını engeller).
                      if (value == null || value.trim().isEmpty) {
                        return 'Alıcı adı boş bırakılamaz'; // Hata mesajı döndürülürse kutu kırmızı olur ve altında bu yazı yazar.
                      }
                      return null; // null dönmesi "Hata yok, giriş geçerli!" anlamına gelir.
                    },
                  ),

                  const SizedBox(height: 16),

                  // 2. INPUT: Transfer tutarı
                  TextFormField(
                    controller: amountController, // Yazılan tutarı amountController içine kaydeder.
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true, // Telefonda harf klavyesi yerine ondalıklı sayı (rakam) klavyesini açar.
                    ),
                    decoration: InputDecoration(
                      labelText: 'Transfer Tutarı',
                      suffixText: '₺', // Kutunun sağ sonunda sabit '₺' simgesi gösterir.
                      prefixIcon: const Icon(Icons.payments), // Sol baştaki para ikonu.
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) { // Tutar doğrulama kuralları:
                      if (value == null || value.trim().isEmpty) {
                        return 'Transfer tutarı giriniz'; // 1. Kural: Boş bırakılamaz.
                      }

                      // replaceAll(',', '.'): Kullanıcı Türkçe klavyeyle virgül (150,50) girerse Dart'ın anlayacağı noktaya (150.50) çevirir.
                      // double.tryParse(): Metni ondalıklı sayıya çevirmeyi dener; eğer harf girilmişse çökmez, null döndürür!
                      final amount = double.tryParse(
                        value.trim().replaceAll(',', '.'),
                      );

                      if (amount == null ||
                          !amount.isFinite ||
                          amount <= 0) {
                        return 'Geçerli bir tutar giriniz'; // 2. Kural: Sayı olmalı ve 0'dan büyük olmalı.
                      }

                      if (amount > _balance) {
                        return 'Yetersiz bakiye'; // 3. Kural: Cüzdandaki mevcut bakiyeden (_balance) fazla para gönderilemez!
                      }

                      return null; // Tüm kontrollerden geçti, hata yok!
                    },
                  ),

                  const SizedBox(height: 24),

                  // Transferi Onaylama Butonu
                  SizedBox(
                    width: double.infinity, // Butonu tam genişlik yapar.
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // formKey.currentState!.validate(): Form içindeki tüm TextFormField'ların validator fonksiyonlarını çalıştırır.
                        // Hepsi null dönerse (hatasızsa) true döner ve if bloğunun içine girer!
                        if (formKey.currentState!.validate()) {
                          final amount = double.parse( // Doğrulamadan geçtiği kesin olduğu için double.parse ile sayıya çevrilir.
                            amountController.text.trim().replaceAll(',', '.'),
                          );

                          final name = nameController.text.trim(); // Alıcı adını alır.
                          final now = DateTime.now(); // İşlemin yapıldığı tam tarih ve saat bilgisini alır.

                          setState(() { // Arayüzdeki bakiyeyi ve işlem listesini güncellemek için setState() başlatılır!
                            // 1. Bakiyeden transfer tutarını düş
                            _balance -= amount;

                            // 2. Yeni işlemi geçmiş listesinin EN BAŞINA (0. indekse) ekle (.add() olsaydı en sonuna eklerdi)
                            _history.insert(
                              0,
                              TransactionItem(
                                id: 'tx_${now.microsecondsSinceEpoch}', // Benzersiz ID üretmek için o anın mikrosaniye zaman damgası kullanılır.
                                title: name,
                                category: 'Hızlı Transfer',
                                date:
                                    '${now.day}.${now.month}.${now.year} '
                                    '${now.hour.toString().padLeft(2, '0')}:' // padLeft(2, '0'): Saat veya dakika tek haneliyse (Örn: 9) başına '0' koyarak '09' yapar.
                                    '${now.minute.toString().padLeft(2, '0')}',
                                amount: amount,
                                isExpense: true, // Para gönderildiği için giderdir (true).
                                icon: Icons.send_rounded,
                              ),
                            );
                          });

                          Navigator.pop(context); // İşlem tamamlandığında açık olan BottomSheet penceresini kapatır.

                          // Ekranın altında yeşil renkli başarı bildirimi (SnackBar) gösterir.
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            const SnackBar(
                              content: Text('Transfer başarıyla oluşturuldu'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Para Gönder'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).whenComplete(() { // whenComplete(): BottomSheet penceresi kapandığında (ister işlem yapılsın ister dışarı tıklanıp kapatılsın) çalışır.
      nameController.dispose(); // Bellek sızıntısını (memory leak) önlemek için controller'ları bellekten temizler.
      amountController.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Para Transferi'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bakiye kartı (Güncel _balance değerini gösterir)
            _buildBalanceCard(),

            const SizedBox(height: 20),

            // Para gönderme butonu (Tıklanınca _openTransferModel çalıştırır)
            _buildTransferButton(),

            const SizedBox(height: 30),

            // İşlem geçmişi başlığı
            const Text(
              'Transfer Geçmişi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // İşlem geçmişi listesi (_history listesini çizer)
            _buildHistoryList(),
          ],
        ),
      ),
    );
  }

  // Bakiye kartı
  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF6366F1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kullanılabilir Bakiye',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            '₺${_balance.toStringAsFixed(2)}', // Transfer yapıldıkça setState() ile anında güncellenen bakiye metni.
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          const Row(
            children: [
              Icon(
                Icons.account_balance_wallet,
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Text(
                'Cüzdan Bakiyesi',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Para gönderme butonu (ElevatedButton.icon kullanımı)
  Widget _buildTransferButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon( // Hem ikon hem metin içeren hazır dolgulu buton.
        onPressed: _openTransferModel, // Tıklandığında alttan açılır transfer formunu (_openTransferModel) açar.
        icon: const Icon(Icons.send_rounded),
        label: const Text('Yeni Transfer'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6366F1),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // Transfer geçmişi listesi
  Widget _buildHistoryList() {
    return ListView.separated(
      shrinkWrap: true, // SingleChildScrollView içinde olduğu için içeriği kadar yer kaplar.
      physics: const NeverScrollableScrollPhysics(), // Kendi kaydırmasını kapatır.
      itemCount: _history.length, // _history listesindeki eleman sayısı kadar kart çizer.
      separatorBuilder: (context, index) {
        return const SizedBox(height: 12); // Kartlar arası 12px boşluk.
      },
      itemBuilder: (context, index) {
        return _buildHistoryCard(_history[index]);
      },
    );
  }

  // Transfer geçmişindeki tek bir işlem kartı
  Widget _buildHistoryCard(TransactionItem transaction) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          // İşlem ikonu
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: transaction.isExpense
                  ? const Color(0xFFFEE2E2)
                  : const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              transaction.icon,
              color: transaction.isExpense
                  ? Colors.red
                  : Colors.green,
            ),
          ),

          const SizedBox(width: 12),

          // Transfer bilgileri
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  transaction.category,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  transaction.date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // İşlem tutarı
          Text(
            '${transaction.isExpense ? '-' : '+'}₺${transaction.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14,
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
// Kullanıcı 'Yeni Transfer' butonuna basar -> _openTransferModel() çalışır ve showModalBottomSheet ile form açılır
// -> Kullanıcı Alıcı Adı ve Tutar girip 'Para Gönder'e basar -> formKey.currentState!.validate() tüm kuralları (boş mu, sayı mı, bakiye yeterli mi) kontrol eder
// -> Doğrulama başarılıysa setState() çalışır -> _balance düşürülür ve _history.insert(0, ...) ile yeni işlem listenin en başına eklenir
// -> Navigator.pop(context) ile BottomSheet kapanır -> SnackBar başarı mesajı gösterir -> Pencere kapandığında whenComplete() çalışarak controller.dispose() ile belleği temizler.

// DOUBLE.PARSE() : Metni sayıya çevirir; eğer metin geçerli bir sayı değilse (Örn: 'abc') uygulama HATA FIRLATIR (FormatException) ve çöker.
//  VS
// DOUBLE.TRYPARSE() : Metni sayıya çevirmeyi dener; eğer metin sayı değilse uygulama ÇÖKMEZ, güvenli şekilde 'null' döndürür (Form doğrulamada her zaman tryParse tercih edilir).
