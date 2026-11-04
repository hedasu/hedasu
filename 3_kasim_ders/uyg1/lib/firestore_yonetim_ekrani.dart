import 'package:flutter/material.dart';
// Flutter'ın Material Design bileşenlerini kullanmamızı sağlar. Scaffold, AppBar, TextField, Column gibi Widget'lar bu paketten gelir.

import 'package:cloud_firestore/cloud_firestore.dart';
// Firebase Firestore veritabanıyla iletişim kurmamızı sağlar. QuerySnapshot, DocumentSnapshot ve FirebaseFirestore gibi sınıflar burada bulunur.

import 'models/ogrenci_model.dart';

// import: Başka bir dosyada tanımlanan sınıfları kullanmamızı sağlar. ../ bir üst klasöre çıkmamızı belirtir.

class FirestoreYonetimEkrani extends StatefulWidget {
  // class: Sınıf tanımlar. extends: Kalıtım alır. StatefulWidget: Değişebilir duruma sahip Widget türüdür.

  const FirestoreYonetimEkrani({super.key});
  // const: Sabit constructor tanımlar. super.key: Widget'ın key bilgisini üst sınıfa iletir. Key: Flutter'ın Widget'ları ayırt etmesine yardımcı olur.

  @override
  // Üst sınıftaki bir metodu yeniden tanımladığımızı belirtir.
  State<FirestoreYonetimEkrani> createState() => _FirestoreYonetimEkraniState();
  // createState(): Widget için State nesnesi oluşturur. State<FirestoreYonetimEkrani>: State'in bağlı olduğu Widget'ı belirtir. =>: Kısa fonksiyon yazımı.
}

class _FirestoreYonetimEkraniState extends State<FirestoreYonetimEkrani> {
  // State: StatefulWidget'ın değişebilir durumunu ve yaşam döngüsünü yönetir. _: Sınıfın bulunduğu Dart kütüphanesi dışından erişimini sınırlar.

  final FirestoreOgrenciServisi servis = FirestoreOgrenciServisi();
  // Servis sınıfından nesne oluşturur. Firestore üzerinde öğrenci ekleme, silme ve güncelleme işlemlerine erişmemizi sağlar. final: Referans yeniden atanamaz.

  final TextEditingController _adSoyadKontrolcusu = TextEditingController();
  // TextEditingController: TextField içindeki metni yönetir. Bu controller öğrenci adı ve soyadını okumak için kullanılır.

  final TextEditingController _projeKontrolcusu = TextEditingController();
  // Proje adı giriş alanındaki metni yönetir.

  final TextEditingController _notKontrolcusu = TextEditingController();
  // Not giriş alanındaki metni yönetir. TextField'dan gelen veri başlangıçta String türündedir.

  @override
  void dispose() {
    // dispose(): State kalıcı olarak kaldırılırken çağrılır. Controller gibi kullanılan kaynakların temizlenmesini sağlar.

    _adSoyadKontrolcusu.dispose();
    // Ad soyad controller'ının kaynaklarını temizler.

    _notKontrolcusu.dispose();
    // Not controller'ının kaynaklarını temizler.

    _projeKontrolcusu.dispose();
    // Proje controller'ının kaynaklarını temizler.

    super.dispose();
    // super: Üst sınıfa erişir. Üst sınıfın dispose() metodunu çağırarak yaşam döngüsü temizliğini tamamlar.
  }

  @override
  Widget build(BuildContext context) {
    // build(): Ekranın Widget ağacını oluşturur. BuildContext: Widget'ın Element ağacındaki konumuyla ilişkili bilgilere erişim sağlar.

    return Scaffold(
      // Scaffold: Material Design sayfa iskeletidir. AppBar ve body gibi bölümleri barındırır.

      appBar: AppBar(
        // AppBar: Ekranın üstündeki uygulama çubuğudur.

        title: const Text("Canllı Firestore Ekranı"),
        // title: AppBar başlığıdır. Text: Ekranda metin gösterir. const: Sabit Widget oluşturur.

        backgroundColor: Colors.amber.shade700,
        // backgroundColor: Arka plan rengini belirler. shade700: Amber renginin koyu tonlarından biridir.
      ),

      body: Column(
        // body: Sayfanın ana içeriğidir. Column: Widget'ları dikey olarak sıralar.

        children: [
          // children: Column içerisinde yer alacak Widget listesidir.

          Padding(
            // Padding: İçerisindeki Widget'ın çevresine boşluk ekler.

            padding: const EdgeInsets.all(12.0),
            // EdgeInsets.all(12.0): Dört taraftan 12 mantıksal piksel boşluk bırakır.

            child: Padding(
              // İç içe ikinci bir Padding kullanılmıştır. Her iki Padding de toplam boşluğa etki eder.

              padding: const EdgeInsets.all(12.0),

              child: Column(
                // Formun içerisindeki giriş alanlarını ve butonu alt alta yerleştirir.

                children: [
                  TextField(
                    // TextField: Kullanıcının metin girmesini sağlar.

                    controller: _adSoyadKontrolcusu,
                    // controller: TextField ile TextEditingController arasında bağlantı kurar.

                    decoration: const InputDecoration(
                      // InputDecoration: TextField'ın etiket, ikon ve diğer görünüm özelliklerini belirler.

                      labelText: "Öğrenci Adı Soyadı",
                      // labelText: Giriş alanının etiketidir.

                      prefixIcon: Icon(Icons.person),
                      // prefixIcon: Giriş alanının başında ikon gösterir. Icons.person: Kişi ikonu.
                    ),
                  ),

                  const SizedBox(height: 8),
                  // SizedBox: Sabit boyutlu boşluk oluşturur. height: 8 dikey boşluk bırakır.

                  Row(
                    // Row: Widget'ları yatay olarak sıralar. Proje adı ve not alanlarını yan yana göstermek için kullanılır.

                    children: [
                      Expanded(
                        // Expanded: Row içerisinde sabit genişlikli elemanlardan kalan kullanılabilir alanı doldurur.

                        child: TextField(
                          // Kullanıcının proje adını gireceği alan.

                          controller: _projeKontrolcusu,
                          // Proje TextField'ını önceden tanımladığımız controller'a bağlar.

                          decoration: const InputDecoration(
                            labelText: "Proje Adı",
                            prefixIcon: Icon(Icons.assignment),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),
                      // Proje adı ve not alanı arasında 8 birim yatay boşluk oluşturur.

                      SizedBox(
                        width: 90,
                        // Not giriş alanının genişliğini 90 birim olarak belirler.

                        child: TextField(
                          controller: _notKontrolcusu,
                          // Not giriş alanını controller'a bağlar.

                          keyboardType: TextInputType.number,
                          // Sayısal girişe uygun klavyeyi açar. Tek başına harf girilmesini tamamen engellemez.

                          decoration: const InputDecoration(
                            labelText: "Not (0-100)",
                            prefixIcon: Icon(Icons.grade),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  // Giriş alanları ile Kaydet butonu arasında 12 birim boşluk bırakır.

                  ElevatedButton.icon(
                    // ElevatedButton: Material butonudur. .icon: İkon ve metin içeren constructor'dır.

                    style: ElevatedButton.styleFrom(
                      // styleFrom(): Butonun renk ve boyut gibi görünüm özelliklerini ayarlar.

                      backgroundColor: Colors.pink,
                      // Butonun arka plan rengini pembe yapar.

                      foregroundColor: Colors.brown,
                      // Butonun yazı ve ikon rengini kahverengi yapar.

                      minimumSize: const Size.fromHeight(44),
                      // Butonun minimum yüksekliğini 44 birim olarak belirler.
                    ),

                    onPressed: _yeniOgrenciKaydet,
                    // onPressed: Butona basıldığında çağrılacak callback'tir. Fonksiyonun referansı verildiği için hemen çalışmaz.

                    icon: const Icon(Icons.cloud_upload),
                    // Buluta yükleme ikonudur.

                    label: const Text("Buluta Kaydet"),
                    // Butonun üzerinde görünen metindir.
                  ),
                ],
              ),
            ),
          ),

          const Divider(thickness: 2),
          // Divider: Form ile öğrenci listesi arasındaki yatay ayırıcı çizgidir. thickness: Kalınlığını belirler.

          Expanded(
            // Expanded: Column içerisinde formdan kalan dikey alanı öğrenci listesine ayırır.

            child: StreamBuilder<QuerySnapshot>(
              // StreamBuilder: Stream'den gelen değişikliklere göre arayüzü yeniden oluşturur. QuerySnapshot: Firestore sorgusunun belge sonuçlarını tutar.

              stream: FirebaseFirestore.instance
                  .collection('ogrenciler')
                  .orderBy('notu', descending: true)
                  .snapshots(),
              // collection(): ogrenciler koleksiyonunu seçer. orderBy(): Notlara göre sıralar. descending: true büyükten küçüğe sıralar. snapshots(): Canlı veri akışı sağlar.

              builder:
                  (
                    BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot,
                  ) {
                    // builder: Veri akışının son durumuna göre gösterilecek Widget'ı oluşturur. AsyncSnapshot: Veri, hata ve bağlantı durumunu içerir.

                    if (snapshot.hasError) {
                      // hasError: Veri akışında hata oluşmuş mu kontrol eder.

                      return Center(
                        child: Text("Bulut Hatası: ${snapshot.error}"),
                      );
                      // Center: İçeriği ortalar. ${snapshot.error}: Hata bilgisini metne ekler.
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // connectionState: Bağlantı durumudur. waiting: İlk verinin gelmesi bekleniyor.

                      return const Center(child: CircularProgressIndicator());
                      // CircularProgressIndicator: Yüklenme sırasında dönen göstergeyi oluşturur.
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      // !: Mantıksal DEĞİL operatörüdür. ||: VEYA operatörüdür. Veri yoksa veya belge listesi boşsa aşağıdaki mesaj gösterilir.
                      // snapshot.data!: Verinin null olmadığını varsayar. docs.isEmpty: Belge listesinin boş olup olmadığını kontrol eder.

                      return const Center(
                        child: Text("Henüz Bulutta kayıtlı öğrenci yoktur."),
                      );
                    }

                    final List<DocumentSnapshot> dokumanlar =
                        snapshot.data!.docs;
                    // DocumentSnapshot: Tek bir Firestore belgesinin anlık görünümüdür. docs: Sorgudan gelen belgeleri listeler.

                    return ListView.builder(
                      // ListView.builder: Kaydırılabilir liste oluşturur. Elemanları gerektiğinde üreterek verimli çalışır.

                      itemCount: dokumanlar.length,
                      // itemCount: Oluşturulacak liste elemanı sayısıdır. length: Listenin eleman sayısını verir.

                      itemBuilder: (context, index) {
                        // itemBuilder: Her liste elemanını oluşturur. index: Elemanın sırasıdır ve 0'dan başlar.

                        final doc = dokumanlar[index];
                        // index konumundaki Firestore belgesini seçer.

                        final ogrenci = OgrenciModel.fromFireStore(doc);
                        // fromFireStore(): Factory constructor'dır. Firestore belgesini OgrenciModel nesnesine dönüştürür.

                        return Dismissible(
                          // Dismissible: Kaydırılarak kaldırılabilen Widget'tır. Burada öğrenci silme işlemi için kullanılır.

                          key: Key(ogrenci.id),
                          // Key: Liste elemanının kimliğini belirler. ogrenci.id: Firestore belge kimliğidir.

                          direction: DismissDirection.endToStart,
                          // endToStart: Yazı yönünün sonundan başına kaydırmadır. Soldan sağa arayüzlerde sağdan sola hareket eder.

                          background: Container(
                            // background: Kaydırma sırasında arkada gösterilen Widget'tır.

                            alignment: Alignment.centerRight,
                            // İçeriği sağ orta tarafa hizalar.

                            padding: const EdgeInsets.only(right: 20),
                            // Sağ taraftan 20 birim boşluk ekler.

                            color: Colors.red,
                            // Silme alanının arka planını kırmızı yapar.

                            child: const Icon(
                              Icons.delete_forever,
                              color: Colors.white,
                            ),
                            // Beyaz renkli silme ikonunu gösterir.
                          ),

                          onDismissed: (direction) {
                            // onDismissed: Liste öğesi kaydırılarak kaldırıldığında çalışan callback'tir.

                            servis.ogrenciSil(ogrenci.id);
                            // Servis sınıfındaki ogrenciSil() metodunu çağırır. ogrenci.id: Silinecek belgenin kimliğidir.
                            // Bu işlem Future döndürür fakat burada await kullanılmıyor.

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${ogrenci.adSoyad} buluttan silindi.',
                                ),
                              ),
                            );
                            // ScaffoldMessenger: Geçici mesajları yönetir. showSnackBar(): Kullanıcıya bilgilendirme mesajı gösterir.
                          },

                          child: ListTile(
                            // ListTile: Hazır liste satırı Widget'ıdır. leading, title, subtitle ve trailing bölümleri vardır.

                            leading: CircleAvatar(
                              // leading: Satırın başında gösterilen Widget. CircleAvatar: Dairesel görünüm oluşturur.

                              backgroundColor: ogrenci.notu >= 80
                                  ? Colors.green
                                  : (ogrenci.notu >= 50
                                        ? Colors.orange
                                        : Colors.red),
                              // Ternary (?:): Kısa if-else yapısıdır. Not >=80 yeşil, >=50 turuncu, diğer durumlarda kırmızı olur.

                              child: Text(
                                '${ogrenci.notu}',
                                // Öğrencinin notunu String olarak gösterir. ${}: String interpolation işlemidir.

                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                // TextStyle: Yazı görünümünü belirler. fontWeight.bold: Kalın yazıdır.
                              ),
                            ),

                            title: Text(
                              ogrenci.adSoyad,
                              // title: Liste satırının ana başlığıdır. ogrenci.adSoyad: Modeldeki ad soyad alanıdır.

                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            subtitle: Text('Proje: ${ogrenci.projeAdi}'),
                            // subtitle: Ana başlığın altında görünen metindir. Proje adını öğrenci modelinden alır.

                            trailing: IconButton(
                              // trailing: Satırın sonundaki Widget. IconButton: İkon içeren tıklanabilir butondur.

                              onPressed: () => _notGuncelleDialog(ogrenci),
                              // () =>: Anonim kısa fonksiyondur. Butona basıldığında seçilen öğrenciyi dialog fonksiyonuna gönderir.

                              icon: const Icon(
                                Icons.edit,
                                color: Colors.amberAccent,
                              ),
                              // Düzenleme ikonunu gösterir.
                            ),
                          ),
                        );
                      },
                    );
                  },
            ),
          ),
        ],
      ),
    );
  }

  void _notGuncelleDialog(OgrenciModel ogrenci) {
    // _notGuncelleDialog: Seçilen öğrencinin notunu güncellemek için pencere açar. OgrenciModel ogrenci: Düzenlenecek öğrenci nesnesidir.

    final TextEditingController notController = TextEditingController(
      text: ogrenci.notu.toString(),
    );
    // Controller'ın başlangıç değerine öğrencinin mevcut notunu yazar. toString(): int değerini String'e dönüştürür.

    showDialog(
      // showDialog(): Mevcut ekranın üzerinde bir pencere açar.

      context: context,
      // context: Dialog'un hangi Widget ağacı üzerinden açılacağını belirtir.

      builder: (context) {
        // builder: Dialog penceresinin Widget ağacını oluşturur.

        return AlertDialog(
          // AlertDialog: Başlık, içerik ve işlem butonları bulunan hazır pencere Widget'ıdır.

          title: Text("${ogrenci.adSoyad} - Not Güncelle"),
          // Başlığa öğrencinin adını ekler.

          content: TextField(
            // content: Dialog'un ana içeriğidir. TextField: Yeni notun girileceği alan.

            controller: notController,
            // Dialog içerisindeki TextField'ı notController'a bağlar.

            keyboardType: TextInputType.number,
            // Sayısal klavyeyi açmayı amaçlar.

            decoration: const InputDecoration(labelText: "Yeni Not"),
          ),

          actions: [
            // actions: Dialog'un altındaki işlem butonlarını tutan listedir.

            TextButton(
              // TextButton: Metin içeren butondur.

              onPressed: () {
                Navigator.pop(context);
                // Navigator.pop(): Açık olan dialog penceresini kapatır.
              },
              child: const Text("İptal"),
            ),

            ElevatedButton(
              // ElevatedButton: Kaydet işlemi için kullanılan butondur.

              onPressed: () async {
                // async: Asenkron Firestore işlemini await ile beklememizi sağlar.

                final yeniNot = int.tryParse(notController.text.trim());
                // trim(): Boşlukları temizler. int.tryParse(): Metni tam sayıya dönüştürmeyi dener, başarısızsa null döndürür.

                if (yeniNot == null || yeniNot < 0 || yeniNot > 100) {
                  // Not null ise, 0'dan küçükse veya 100'den büyükse geçersiz kabul edilir. ||: VEYA operatörüdür.

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Lütfen 0-100 arasında not giriniz."),
                    ),
                  );

                  return;
                  // return: Fonksiyonu sonlandırır ve Firestore güncellemesini engeller.
                }

                try {
                  // try: Hata oluşabilecek güncelleme işlemini çalıştırır.

                  await servis.ogrenciNotuGuncelle(ogrenci.id, yeniNot);
                  // Servisin güncelleme metodunu çağırır. İlk parametre belge ID'si, ikinci parametre yeni nottur. await işlem sonucunu bekler.

                  if (!context.mounted) return;
                  // context.mounted: Dialog context'inin hâlâ geçerli olup olmadığını kontrol eder.

                  Navigator.pop(context);
                  // Güncelleme başarılıysa dialog'u kapatır.

                  if (!mounted) return;
                  // mounted: State nesnesinin hâlâ Widget ağacında bulunup bulunmadığını kontrol eder.

                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(content: Text("Öğrenci notu güncellendi.")),
                  );
                  // Ana ekran üzerinden başarı mesajı gösterir.
                } catch (e) {
                  // catch: Güncelleme işlemi sırasında hata oluşursa çalışır. e: Yakalanan hatadır.

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Not güncelleme hatası: $e")),
                  );
                  // $e: Yakalanan hata bilgisini metne ekler.
                }
              },

              child: const Text("Kaydet"),
              // Kaydet butonunun görünen metnidir.
            ),
          ],
        );
      },
    ).whenComplete(() => notController.dispose());
    // whenComplete(): Dialog kapandığında çalışır. dispose(): Controller'ın kullandığı kaynakları temizler.
  }

  Future<void> _yeniOgrenciKaydet() async {
    // Future<void>: Asenkron işlem tamamlandığında herhangi bir değer döndürmez.
    // async: Fonksiyon içerisinde await kullanmamızı sağlar.

    final adSoyad = _adSoyadKontrolcusu.text.trim();
    // .text: TextField'a girilen metni okur. trim(): Başındaki ve sonundaki boşlukları temizler.

    final proje = _projeKontrolcusu.text.trim();
    // Proje adı alanındaki metni okur ve gereksiz boşlukları temizler.

    final not = int.tryParse(_notKontrolcusu.text.trim());
    // int.tryParse(): String değeri int'e çevirmeyi dener. Başarısız olursa null döndürür.
    // Önceki ?? 0 ifadesini kaldırdık çünkü hatalı not girişini 0 olarak kabul etmek istemiyoruz.

    if (adSoyad.isEmpty || proje.isEmpty) {
      // isEmpty: Metin boş mu kontrol eder. ||: Koşullardan en az biri doğruysa if çalışır.

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen ad soyad ve proje adını giriniz.'),
        ),
      );
      // Kullanıcıya eksik bilgi uyarısı gösterir.

      return;
      // Fonksiyonu sonlandırır. Firestore'a veri gönderilmez.
    }

    if (not == null || not < 0 || not > 100) {
      // Not sayı değilse, 0'dan küçükse veya 100'den büyükse geçersiz kabul edilir.
      // ||: Mantıksal VEYA operatörüdür.

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen 0-100 arasında geçerli bir not giriniz.'),
        ),
      );

      return;
      // Geçersiz not varsa kayıt işlemini durdurur.
    }

    try {
      // try: Hata oluşabilecek işlemleri çalıştırır.

      await servis.ogrenciEkle(adSoyad: adSoyad, projeAdi: proje, notu: not);
      // servis: FirestoreOgrenciServisi nesnemiz.
      // ogrenciEkle(): Öğrenciyi Firestore'a ekleyen metot.
      // adSoyad, projeAdi, notu: İsimlendirilmiş parametrelerdir (named).
      // await: Firestore işleminin tamamlanmasını bekler.

      if (!mounted) return;
      // mounted: State nesnesinin hâlâ Widget ağacında olup olmadığını kontrol eder.
      // Asenkron işlemden sonra context kullanmadan önce bu kontrolü yapıyoruz.

      _adSoyadKontrolcusu.clear();
      _projeKontrolcusu.clear();
      _notKontrolcusu.clear();
      // clear(): Controller içerisindeki metni temizler.
      // Böylece başarılı kayıt sonrası form boşalır.

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Öğrenci başarıyla buluta kaydedildi.')),
      );
      // Kayıt başarılıysa kullanıcıya mesaj gösterir.
    } catch (e) {
      // catch: Firestore işlemi sırasında hata oluşursa çalışır.
      // e: Yakalanan hata nesnesidir.

      if (!mounted) return;
      // Asenkron işlem sonrası State hâlâ mevcut mu kontrol eder.

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Öğrenci kaydedilemedi: $e')));
      // $e: Hata bilgisini String içerisine ekler.
    }
  }
  //Buluta Kaydet butonuna basılır->Controller'lardan bilgiler okunur->Girilen bilgiler geçerli mi?->hayır ise SnackBar gösterilir ekran durur || evet is firestorea kayıt gönderir -> Kayıt başarılıysa alanlar temizlenir ve mesaj gösterilir
}
// KODUN MİMARİSİ :  FirestoreYönetimEkrani: kullanıcının gördüğüve etkileşim kurduğu ekran <=> FirestoreOgrenciServisi: Öğrenci ekleme,silme ve güncelleme işlemleri <=> Firebase Firestore : öğrnci kayıtlarının saklandığı veritabanı
