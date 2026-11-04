import 'package:cloud_firestore/cloud_firestore.dart'; //cloud_firestore: firebase firestore veritabanı

// DocumentSnapshot ve TimeStamp gibi sınıflaı bu paket ile kullanıyoruz.

class OgrenciModel {
  //model: verinin uyg. içinde nasıl temsil edileceğini belirleyen y.pı (OgrenciModel: bir ogrencinin hnagi bilg. sahip olacağını tanımlar)
  final String
  id; // final: Değişkene bir kez değer atanır, sonradan yeniden atanamaz.
  final String adSoyad;
  final String projeAdi;
  final int notu;
  final DateTime kayitTarihi;

  const OgrenciModel({
    // Constructor (kurucu metot): Nesne oluşturulurken çalışır. | const: Uygun koşullarda derleme zamanı sabiti nesne oluşturabiliriz. | {}: Parametrelerin isimlendirilmiş (named) olduğunu gösterir.
    required this.id, // required: Parametrenin gönderilmesini zorunlu tutar. | this.id: Gelen id değerini sınıfın id alanına atar.
    required this.adSoyad,
    required this.projeAdi,
    required this.notu,
    required this.kayitTarihi,
  });

  // factory: Nesne oluşturmak için kullanılan özel constructor türü.
  // fromFireStore: Bizim verdiğimiz isim, Dart'ın hazır fonksiyonu değil.
  // DocumentSnapshot: Firestore'dan okunan bir belgenin anlık görünümü.
  // doc: Firestore'dan gelen belgeyi temsil eden parametre.
  //snapshot: veri çekerken yedeğini almak. dosya bazlı da alınabilir.
  factory OgrenciModel.fromFireStore(DocumentSnapshot doc) {
    final veri = doc.data() as Map<String, dynamic>? ?? {};
    // doc.data(): Belgenin içindeki alanları getirir.
    // as: Gelen veriyi belirtilen tipe dönüştürmeden, o tip olarak ele alır.
    // Map<String, dynamic>: Anahtar-değer yapısında veri tutar.(key,valu-> ismi ve karşılığı)
    // String: Anahtarların metin olduğunu gösterir.
    // dynamic: Değerlerin farklı tiplerde olabileceğini gösterir.
    // ?: Verinin null olabileceğini belirtir.
    // ?? {}: Veri null ise boş bir Map kullanır.

    //birini doctan diğerini veriden alıyoruz. çünkü id yi sistem otomatik atıyor.
    return OgrenciModel(
      //return oluuşturulan nesneyi çağıran yere geri gönderir.(voidde bu geri dönüş yok)
      id: doc.id, // doc.id: Belgenin kimliğini doğrudan Firestore'dan alır.Çünkü belge ID'si, belge içindeki alanlardan ayrı tutulur.
      adSoyad: veri['adSoyad'] as String? ?? "İsimsiz Öğrenci Shad", // veri['adSoyad']: Map içerisindeki adSoyad değerini alır. | as String?: Değeri String veya null olarak kabul eder. | ?? : Değer null ise varsayılan metni kullanır.
      projeAdi: veri['projeAdi'] as String? ?? "Henüz proje yok.",
      notu: (veri['notu'] as num?)?.toInt() ?? 0,
      kayitTarihi:
          (veri['kayitTarihi'] as Timestamp?)?.toDate() ?? DateTime.now(),
      // Timestamp: Firestore'un tarih-saat veri tipi.|  ?.toDate(): Timestamp varsa Dart DateTime türüne dönüştürür. | ?? DateTime.now(): Tarih null ise şu anki tarihi kullanır.
    );
  }
}

// BU PARTIN ÇALIŞMA MANTIĞI
//  Firestore belgesi: DocumentSnapshot doc -> Verileri Ayır : doc.id ve doc.data() -> factory OgrenciModel.fromFireStore(doc) : Tipleri kontrol et, gerekli dönüşümlri yap. -> ogrenciModel Nesnesi : Öğğrenci bilgileri artık Dart nesnesi olarak kullanılabiir.

//FACTORY NEDEN KULLANILIYOR : normal constructorda bilgileri biz veriyoruz. Factory constructorda  Firestore belgesini(vertabanı) veriyoruz o veritabanından bilgileri çekiyor. factory kullanmak zorunlu değil; fakat Firestore verilerini modele dönüştürmek için oldukça kullanışlı. Ayrıca factory constructor her zaman yeni nesne üretmek zorunda değildir, var olan bir nesneyi de döndürebilir.

// doc.id : belgenin kimliği
// doc.data() : belgenin çindeki alanlar

//yukarıdaki bilgiler veritabanında nasıl yönetilecek aşağıdaki sınıf ile bunu belirtiriz [CRUD İLE (Create Read Update Delete)]
class FirestoreOgrenciServisi {
  //FirestoreOgrenciServisi : Öğrencilerle ilgili veritabanı işlemlerini tek bir yerde toplaığımız sınıf.
  final CollectionReference _ogrencilerKoleksiyonu = FirebaseFirestore.instance
      .collection('ogrenciler'); //CollectionReference: Firestore'daki koleksiyonu temsil eden sınıf  | FirebaseFirestore.instance: Firestore'a erişim sağlayan instance. (instance:sınıfın kullanılabiilir nesne örneği) | collection('ogrenciler): öğrenciler koleksiyonuna erişir. BU SATIR VERİ ÇEKMEZ,KOLEKSİYONA REFERANS OLUŞTURUR.

  Future<void> ogrenciEkle({
    // future : sonucu gelecekte tamamlanacak async işlem | void: değer döndürmez | {:isimlendirilmiiş parametreler}
    required String adSoyad, // required orunlu old. belirtir. “Bu fonksiyon çalıştırılırken bu bilginin mutlaka verilmesi gerekiyor mu?” sorusunun cevabına göre kullanıyoruz

    required String projeAdi,
    required int notu,
  }) async {
    // async: Bu metot içerisinde await kullanılabileceğini belirtir.
    try {
      //hata oluşturabilecek işşlemleri çalıştırır.
      await _ogrencilerKoleksiyonu.add({
        // await: Firestore ekleme işleminin tamamlanmasını bekler.| add(): Koleksiyona yeni belge ekler.| Firestore yeni belge için otomatik ID oluşturur.| {}: Map, yani anahtar-değer çiftleri. sol:key,sağ:value
        'adSoyad': adSoyad,
        'projeAdi': projeAdi,
        'notu': notu,
        'kayitTarihi': FieldValue.serverTimestamp(),
      });
      print('Öğrenci başarıyla kaydedildi');
    } catch (e) {
      // catch: try içerisinde hata oluşursa çalışır.|e: Yakalanan hata nesnesi.

      print(
        'Öğrenci ekleme başarısız: $e',
      ); // $e: String interpolation, hata değerini metne ekler.
      rethrow; //rethrow: hatayı yakaladıktan sonra kullanıcıya göstermek için. ||  Yakalanan hatayı çağıran üst katmana tekrar fırlatır. Böylece örneğin arayüz bu hatayı yakalayıp gösterebilir. rethrow tek başına kullanıcıya mesaj göstermez.
    }
  }

  //void yanıtsız kalmadığı sürece bu fonksiyonu her türlü bitirir. await sayesinde de asnkron işlemin tamamlanmasını bekleriz.Future<void> ise işlem tamamlandığında bir sonuç değeri döndürmeyeceğini belirtir.
  Future<void> ogrenciIdIleKaydet({
    required String tcNo,
    required String adSoyad,
    required String projeAdi,
  }) async {
    await _ogrencilerKoleksiyonu.doc(tcNo).set({
      // doc(tcNo): Kimliği tcNo olan belgeyi hedefler. || set(): Belge yoksa oluşturur, varsa üzerine veri yazar ||Burada Firestore otomatik ID üretmek yerine bizim gönderdiğimiz ID kullanılır.
      'adSoyad': adSoyad,
      'projeAdi': projeAdi,
      'guncellemeTarihi': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true)); //merge göndermezsek her seferinde diğer verileri silerdi. : merge olmadan set() mevcut belgeyi verilen verilerle değiştirir.merge: true -> Diğer alanları koruyarak gönderilenleri yazar.
  }

  Future<List<OgrenciModel>> tumOgrencileriGetir() async {
    // Future<List<OgrenciModel>>: İşlem tamamlanınca öğrenci listesi döndürür.
    try {
      final QuerySnapshot snapshot = await _ogrencilerKoleksiyonu
          .orderBy('notu', descending: true)
          .get();
      // get(): Verileri Firestore'dan bir defa getirir.

      return snapshot.docs
          .map((doc) => OgrenciModel.fromFireStore(doc))
          .toList();
      // map(): Belgeleri OgrenciModel nesnelerine dönüştürür.
      // toList(): Sonucu liste hâline getirir.
    } catch (e) {
      print("veri çekme hatası: $e");
      return [];
      // Hata olursa boş liste döndürür.
    }
  }

  Future<void> ogrenciNotuGuncelle(String documanId, int yeniNot) async {
    // documanId: güncellenecek belge ıdsi,yniNot: belgeye yazılacak yeni not :POSİTİONAL PARAMETRE : konumsal yani parametler sıraya göre değer alır
    await _ogrencilerKoleksiyonu.doc(documanId).update({
      // doc(documanId): Güncellenecek belgeyi seçer. update(): Var olan belgenin belirli alanlarını günceller.Belge yoksa hata verir.
      'notu': yeniNot,
      'sonDuzenleme':
          FieldValue.serverTimestamp(), // Son düzenleme zamanını da kaydeder.
    });
  }

  Future<void> ogrenciSil(String documanId) async {
    // Silinecek belgenin ID'sini parametre olarak alıyoruz.
    await _ogrencilerKoleksiyonu.doc(documanId).delete(); // doc(documanID): Belgeyi hedefler.|| delete(): Belgeyi Firestore'dan siler.|| await: Silme isteğinin tamamlanmasını bekler.
    print('$documanId referanslı veri tamammen silindi');
  }
}
//DocumentSnapshot → Tek bir belgenin anlık görünümü. || QuerySnapshot → Bir sorgunun sonucunda elde edilen belge kümesinin anlık görünümü.
