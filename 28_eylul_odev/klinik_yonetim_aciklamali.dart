//1.Enumları (derleme Zamanı güvenliği)

//enum : dartta seçenekleri önceden belli olan değerler için kullanır.

enum HizmetKategorisi {
  ciltYenileme,
  medikalEstetik,
  lazerEpilasyon,
  Lipo
}
// HizmetKategorisi enum'u klinikte sunulan hizmet türlerini tutar.
// Bir hizmet yukarıdaki 4 seçenek ile sınırlandırılmıştır.


enum SeansDurumu {
  bekliyor,
  odadaIslemde,
  tamamlandi,
  iptalEdildi
}
// SeansDurumu enum'u bir seansın hangi durumda olduğunu belirtir.
// böylece seans sadece tanımlanan seçeneklerden biri olabilir.


enum OdemeYontemi {
  krediKarti,
  havaleEft,
  nakit,
  klinikPaketKredisi
}
// OdemeYontemi enum'u kullanılabilecek ödeme yöntemlerini belirtir.
// yukarıdaki 4 seçenek ile sınırlandırılmıştır.



//2.Danışan (müşteri) Modeli

//class : bir nesnenin hangi bilgileri ve işlemleri içereceğini belirlemek için kullanılır.
//burada Danisan adında bir class oluşturuyoruz.
class Danisan {

  //final : değer bir kere verildikten sonra sonradan değiştirilemez.
  //String : metinsel değerleri tutmak için kullanılır.
  //danışanın id bilgisini tutar.
  final String id;

  //danışanın ad ve soyad bilgisini tutar.
  final String adSoyad;

  //danışanın telefon numarasını tutar.
  final String telefon;

  //bool : sadece true veya false değerini alabilir.
  //danışanın vip üye olup olmadığını tutar.
  final bool vipUyeMi;

  //List : birden fazla değeri bir arada tutmak için kullanılır.
  //<String> listenin sadece String değerler tutacağını belirtir.
  //burada danışanın alerjilerini liste halinde tutuyoruz.
  final List<String> alerjiler; // boş olabilir ama null olamaz

  //String? : değişkenin String değer veya null alabileceğini belirtir.
  //her danışanın özel cilt notu olmak zorunda olmadığı için null olabilir.
  final String? ozelCiltNotu; // Opsiyonel Null olabilir


  //constructor : Danisan classından yeni bir nesne oluştururken
  //hangi bilgilerin alınacağını belirler.
  const Danisan({

    //required : bu değerin nesne oluşturulurken girilmesini zorunlu yapar.
    //this.id ile girilen id değerini yukarıdaki id değişkenine atıyoruz.
    required this.id,
    required this.adSoyad,
    required this.telefon,

    //vip bilgisi girilmezse otomatik olarak false olur.
    this.vipUyeMi = false,

    //alerji bilgisi girilmezse otomatik olarak boş liste oluşturulur.
    this.alerjiler = const [],

    //required olmadığı için özel cilt notunu girmek zorunlu değildir.
    this.ozelCiltNotu,
  });


  //get : bir bilgiyi hesaplayıp bize geri döndürmek için kullanılır.
  //=> : tek satırlık işlemlerde sonucu direkt döndürmek için kullanılır.
  //isNotEmpty listenin boş olup olmadığını kontrol eder.
  //alerji listesi boş değilse hassasCiltMi true olur.
  bool get hassasCiltMi => alerjiler.isNotEmpty;


  //Bilgi özet kartı

  //danışanın bilgilerini tek bir metin halinde oluşturuyoruz.
  String get bilgiOzeti {

    //isEmpty : listenin boş olup olmadığını kontrol eder.
    // ? : koşul doğruysa ilk değeri, yanlışsa : işaretinden sonraki değeri seçer.
    final String alerjiBilgisi = alerjiler.isEmpty
        ? "Kayıtlı Alerji Yok"

        //join : listedeki değerleri tek bir String haline getirir.
        //burada alerjilerin arasına virgül koyuyoruz.
        : "Alerjiler: ${alerjiler.join(', ')}";

    //?? : sol taraftaki değer null ise sağ taraftaki değeri kullanır.
    //özel cilt notu yoksa aşağıdaki yazı gösterilir.
    final String notBilgisi =
        ozelCiltNotu ?? "Özel medikal not girilmemiş";

    //vipUyeMi true ise VİP, false ise Standart yazılır.
    final String vipRozeti = vipUyeMi ? "VİP" : "Standart";

    //return : oluşturduğumuz sonucu geri döndürür.
    //$ ile değişkenlerin değerlerini String içine ekleyebiliyoruz.
    return "$vipRozeti $adSoyad ($telefon) | $alerjiBilgisi | Not: $notBilgisi";
  }
}



//3.Seans (randevu) Modeli

//SeansKaydi classı her randevunun bilgilerini tutmak için oluşturuldu.
class SeansKaydi {

  //her seansın kendine ait kodunu tutar.
  final String seansKodu;

  //Danisan türünde bir değişken oluşturuyoruz.
  //böylece seansın hangi danışana ait olduğunu tutabiliyoruz.
  final Danisan danisan;

  //kategori değişkeni yukarıda oluşturduğumuz
  //HizmetKategorisi enumundaki değerlerden birini alabilir.
  final HizmetKategorisi kategori;

  //yapılacak işlemin adını tutar.
  final String islemAdi;

  //double : ondalıklı sayıları tutmak için kullanılır.
  //işlemin birim fiyatını tutuyoruz.
  final double birimFiyat;

  //işlemin kaç seans yapılacağını tutar.
  final int seansSayisi;

  //indirim yüzdesini tutar. örneğin 10.0 = %10 indirim.
  final double indirimOrani; // Örn 10.0

  //uzman bilgisi boş olabileceği için String? kullandık.
  final String? sorumluUzman;

  //final kullanmadık çünkü seansın durumu sonradan değişebilir.
  //örneğin bekleyen bir seans tamamlandı durumuna geçebilir.
  SeansDurumu durum;

  //ödeme yapılmadan önce ödeme tipi belli olmayacağı için null olabilir.
  //seans tamamlandığında ödeme yöntemi atanabilir.
  OdemeYontemi? odemeTipi;


  //SeansKaydi nesnesi oluşturmak için constructor.
  SeansKaydi({

    //bu bilgilerin girilmesi zorunludur.
    required this.seansKodu,
    required this.danisan,
    required this.kategori,
    required this.islemAdi,
    required this.birimFiyat,

    //seans sayısı girilmezse otomatik olarak 1 kabul edilir.
    this.seansSayisi = 1,

    //indirim girilmezse otomatik olarak %0 kabul edilir.
    this.indirimOrani = 0.0,

    //uzman bilgisini girmek zorunlu değildir.
    this.sorumluUzman,

    //durum girilmezse seans otomatik olarak bekliyor durumunda başlar.
    this.durum = SeansDurumu.bekliyor,

    //ödeme bilgisi daha sonra girilebileceği için zorunlu değildir.
    this.odemeTipi,
  });


  //brüt tutarı hesaplıyoruz.
  //bir seansın fiyatı ile seans sayısını çarpıyoruz.
  double get brutTutar => birimFiyat * seansSayisi;


  //uygulanacak toplam indirim tutarını hesaplıyoruz.
  double get indirimTutari {

    //ilk olarak normal indirim oranını toplamOran değişkenine atıyoruz.
    double toplamOran = indirimOrani;

    //if : verilen koşul doğruysa süslü parantez içindeki kod çalışır.
    //danışan vip üyeyse normal indirimine ekstra %10 ekliyoruz.
    if (danisan.vipUyeMi) {
      toplamOran += 10.0;
    }

    //brüt tutarın yüzde kaçının indirim olacağını hesaplayıp geri döndürüyoruz.
    return brutTutar * (toplamOran / 100.0);
  }


  //net tutar = brüt tutar - indirim tutarı.
  //yani danışanın ödeyeceği son fiyatı hesaplıyoruz.
  double get netTutar => brutTutar - indirimTutari;
}



//4.Yönetim Servisi

//KlinikYoneticisi classı danışanları ve seansları yönetmek için kullanılır.
class KlinikYoneticisi {

  //hangi şubenin yönetildiğini tutar.
  final String subeAdi;

  //SeansKaydi türündeki bütün seansları bir List içinde tutuyoruz.
  //[] listenin başlangıçta boş olduğunu belirtir.
  //_ ile başlayan değişkenler private olur yani sadece bu class içinde kullanılır.
  final List<SeansKaydi> _seanslar = [];

  //Map : verileri anahtar-değer şeklinde tutmak için kullanılır.
  //burada String danışanın id'si, Danisan ise o id'ye ait danışan nesnesidir.
  final Map<String, Danisan> _danisanRehberi = {};


  //KlinikYoneticisi oluşturulurken şube adının girilmesi zorunludur.
  KlinikYoneticisi({required this.subeAdi});



  //Danışan kaydetme

  //void : bu metodun geriye bir değer döndürmeyeceğini belirtir.
  //parametre olarak Danisan türünde bir danışan alır.
  void danisanKaydet(Danisan danisan) {

    //danışanın id'sini anahtar yapıp danışanı Map içine kaydediyoruz.
    _danisanRehberi[danisan.id] = danisan;

    //print : ekrana yazı yazdırmak için kullanılır.
    //danışan vip ise VİP değilse Standart yazdırıyoruz.
    print(
      "Rehbere Eklendi: ${danisan.adSoyad} (${danisan.vipUyeMi ? "VİP" : "Standart"})",
    );
  }



  //Randevu oluşturma

  //oluşturulan SeansKaydi nesnesini sisteme ekler.
  void randevuOlustur(SeansKaydi seans) {

    //.add : listeye yeni bir eleman eklemek için kullanılır.
    _seanslar.add(seans);

    //eklenen randevunun bilgilerini ekrana yazdırıyoruz.
    print(
      "Randevu Kaydedildi [${seans.seansKodu}]: ${seans.danisan.adSoyad}->${seans.islemAdi}",
    );
  }



  //Seansı tamamlama

  //seans kodunu ve ödeme yöntemini parametre olarak alır.
  //ikisi de required olduğu için girilmesi zorunludur.
  void seansiTamamla({
    required String seansKodu,
    required OdemeYontemi odeme,
  }) {

    //for : bir işlemi listedeki elemanlar için tekrar tekrar yapmamızı sağlar.
    //burada _seanslar listesindeki bütün seansları sırayla kontrol ediyoruz.
    for (var seans in _seanslar) {

      //== iki değerin birbirine eşit olup olmadığını kontrol eder.
      //listedeki seans kodu aradığımız seans koduna eşitse aşağıdaki işlemler yapılır.
      if (seans.seansKodu == seansKodu) {

        //seansın durumunu tamamlandı olarak değiştiriyoruz.
        seans.durum = SeansDurumu.tamamlandi;

        //seansın ödeme yöntemini verilen ödeme yöntemi olarak kaydediyoruz.
        seans.odemeTipi = odeme;

        //toStringAsFixed(2) sayıyı virgülden sonra 2 basamak olacak şekilde yazdırır.
        //.name enum değerinin adını almamızı sağlar.
        print(
          "Seans Tamamlandı: [${seans.seansKodu}]: ${seans.netTutar.toStringAsFixed(2)} tahsil edildi (${odeme.name})",
        );
        //HATA: burada return olmadığı için seans bulunsa bile metot bitmiyor.
        //for döngüsü bittikten sonra aşağıdaki hata mesajına geçiyor.
        //bu yüzden seans başarıyla tamamlansa bile "seans bulunamadı" mesajı da yazdırılıyor.
      }
    }

    //seans bulunamazsa hata mesajı yazdırılır.
    print("Hata [$seansKodu] kodlu seans bulunamadı");

    //return metodun çalışmasını burada bitirir.
    return;
  }



  //Seansı iptal etme

  //seansKodu zorunlu olarak alınır.
  //iptalNedeni String? olduğu için girilmesi zorunlu değildir.
  void seansiIptalEt(String seansKodu, {String? iptalNedeni}) {

    //bütün seansları sırayla kontrol ediyoruz.
    for (var seans in _seanslar) {

      //aradığımız kodla eşleşen seansı buluyoruz.
      if (seans.seansKodu == seansKodu) {

        //bulunan seansın durumunu iptal edildi olarak değiştiriyoruz.
        seans.durum = SeansDurumu.iptalEdildi;

        //iptal nedeni varsa onu yazdırıyoruz.
        //null ise "Gerekçe Belirtilmedi" yazdırıyoruz.
        print(
          "Seans İptal Edildi [${seans.seansKodu}]: ${iptalNedeni ?? "Gerekçe Belirtilmedi"}",
        );

        //seansı bulduğumuz için metodun çalışmasını bitiriyoruz.
        return;
      }
    }
  }



  //5.Finansal Rapor Metotları(fonksiyonel dart)

  //tamamlanmış seanslardan gerçekten tahsil edilen toplam parayı hesaplar.
  double get toplamTahsilEdilenCiro => _seanslar

      //.where : listedeki elemanları verdiğimiz koşula göre filtreler.
      //burada sadece tamamlanmış seansları seçiyoruz.
      .where((s) => s.durum == SeansDurumu.tamamlandi)

      //.fold : listedeki değerleri birleştirerek tek bir sonuç oluşturur.
      //0.0 toplamın başlangıç değeridir.
      //her seansın net tutarını toplama ekliyoruz.
      .fold(0.0, (toplam, s) => toplam + s.netTutar);


  //henüz tamamlanmamış ama gerçekleşmesi beklenen seansların
  //toplam potansiyel gelirini hesaplar.
  double get beklenenPotansiyelCiro => _seanslar

      //bekliyor veya işlemde olan seansları seçiyoruz.
      .where(
        (s) =>
            s.durum == SeansDurumu.bekliyor ||
            s.durum == SeansDurumu.odadaIslemde,
      )

      //seçilen seansların net tutarlarını topluyoruz.
      .fold(0.0, (toplam, s) => toplam + s.netTutar);



  //6.kategori bazlı seans sayıları

  //her hizmet kategorisinde kaç seans olduğunu hesaplayan metod.
  //sonuç Map olarak döndürülür.
  Map<HizmetKategorisi, int> kategoriBazliSeansDagilimi() {

    //başlangıçta boş bir Map oluşturuyoruz.
    final Map<HizmetKategorisi, int> dagilim = {};

    //.values enum içindeki bütün seçeneklere ulaşmamızı sağlar.
    //her kategori için başlangıç değerini 0 yapıyoruz.
    for (var kat in HizmetKategorisi.values) {
      dagilim[kat] = 0;
    }

    //sistemdeki bütün seansları sırayla geziyoruz.
    for (var s in _seanslar) {

      //seans hangi kategoriye aitse o kategorinin sayısını 1 artırıyoruz.
      //?? 0 ile değer bulunamazsa 0 kabul edilmesini sağlıyoruz.
      dagilim[s.kategori] = (dagilim[s.kategori] ?? 0) + 1;
    }

    //hazırladığımız dağılım Map'ini geri döndürüyoruz.
    return dagilim;
  }



  //Görevli uzmanları bulma

  //Set : List'e benzer ama aynı değeri birden fazla kez tutmaz.
  //bu yüzden aynı uzman birden fazla seansta olsa bile bir kere gösterilir.
  Set<String> gorevliUzmanKadrosu() {

    //map ile her seanstan sorumlu uzman bilgisini alıyoruz.
    //whereType<String>() ile null olanları çıkarıp sadece String olanları alıyoruz.
    //toSet() ile sonuçları Set'e çeviriyoruz.
    return _seanslar
        .map((s) => s.sorumluUzman)
        .whereType<String>()
        .toSet();
  }



  //Uzmansız kalan seanslar

  //geriye SeansKaydi türünde bir List döndürür.
  List<SeansKaydi> uzmansizSeanslariGetir() {

    //sorumluUzman değeri null olan seansları buluyoruz.
    //.toList() sonucu tekrar List haline getirir.
    return _seanslar
        .where((s) => s.sorumluUzman == null)
        .toList();
  }



  //7.Gün sonu raporu

  //sistemdeki seansları ve finansal bilgileri ekrana yazdırır.
  void gunSonuRaporuYazdir() {

    //raporun başlığını yazdırıyoruz.
    print("Günlük Seans ve İşlem Çizelgesi");
    print("---------------------------------------");

    //.padRight : yazının sağına boşluk ekleyerek sütunların daha düzgün görünmesini sağlar.
    print(
      "${'Kod'.padRight((10))} | "
      "${'Danışan'.padRight(16)} | "
      "${'İşlem'.padRight(20)} | "
      "${'Uzman'.padRight(18)} | "
      "${'Tutar'.padRight(10)} | "
      "${'Durum'} | ",
    );

    print("---------------------------------------");


    //bütün seansları tek tek yazdırmak için listeyi geziyoruz.
    for (var s in _seanslar) {

      //sorumlu uzman varsa uzman adı alınır.
      //null ise "Nöbetçi Bekliyor" yazılır.
      final String uzman =
          s.sorumluUzman ?? " Nöbetçi Bekliyor";


      //switch : bir değişkenin farklı değerlerine göre farklı işlem yapmak için kullanılır.
      //burada seansın durumuna göre ekranda gösterilecek yazıyı belirliyoruz.
      final String durumRozet = switch (s.durum) {

        SeansDurumu.tamamlandi => "Tamamlandı",

        SeansDurumu.odadaIslemde => "İşlemde",

        SeansDurumu.bekliyor => "Bekliyor",

        SeansDurumu.iptalEdildi => "İptal",
      };


      //her seansın bilgilerini tablo şeklinde ekrana yazdırıyoruz.
      print(
        "${s.seansKodu.padRight(10)} | "
        "${s.danisan.adSoyad.padRight(10)} | "
        "${s.islemAdi.padRight(10)} | "
        "${uzman.padRight(10)} | "
        "${s.netTutar.toStringAsFixed(2).padRight(10)} | "
        "$durumRozet",
      );
    }


    //seans listesinden sonra finansal özet kısmına geçiyoruz.
    print("---------------------------------------");
    print("Finansal Özet:");

    //tamamlanmış seanslardan tahsil edilen toplam parayı yazdırıyoruz.
    print(
      " * Gerçekleşen (kasadaki net ciro) : ${toplamTahsilEdilenCiro.toStringAsFixed(2)}",
    );

    //bekleyen ve işlemde olan seanslardan gelebilecek parayı yazdırıyoruz.
    print(
      " * Bekleyen Potansiyen Alacak : ${beklenenPotansiyelCiro.toStringAsFixed(2)}",
    );

    //.length listenin içinde kaç eleman olduğunu verir.
    //burada toplam randevu sayısını yazdırıyoruz.
    print(" * Toplam Seans : ${_seanslar.length} Randevu");

    print("---------------------------------------");
    print("Aktif Uzmanlar");


    //görevliUzmanKadrosu metodunu çalıştırıp uzmanları alıyoruz.
    final uzmanlar = gorevliUzmanKadrosu();

    //uzmanlar Set'i boşsa kayıtlı uzman bulunamadığını yazdırıyoruz.
    if (uzmanlar.isEmpty) {
      print("Kayıtlı Uzman Bulunamadı");

    //else : if koşulu yanlış olduğunda çalışır.
    } else {

      //uzmanları virgülle ayırarak ekrana yazdırıyoruz.
      print(" ${uzmanlar.join(', ')}");
    }


    //uzmanı olmayan seansları getiriyoruz.
    final uzmansizlar = uzmansizSeanslariGetir();

    //uzmansız seans varsa uyarı veriyoruz.
    if (uzmansizlar.isNotEmpty) {

      //kaç tane uzmansız seans olduğunu yazdırıyoruz.
      print(
        "Dikkat: ${uzmansizlar.length} adet seansa henüz uzman atanmamıştır",
      );

      //uzmansız seansların hepsini tek tek geziyoruz.
      for (var u in uzmansizlar) {

        //seans kodunu, danışanı ve işlemi ekrana yazdırıyoruz.
        print(
          "->[${u.seansKodu}] ${u.danisan.adSoyad} (${u.islemAdi})",
        );
      }
    }

    print("---------------------------------------");
  }
}



//8.Main kısmı

//main : Dart programının çalışmaya başladığı ana bölümdür.
//program çalıştırıldığında ilk olarak buradaki kodlar çalışır.
void main() {

  print("Klinik yönetim sistemi başlatılıyor....");


  //KlinikYoneticisi classından yonetici adında bir nesne oluşturuyoruz.
  //şube adı olarak Softito Bağcılar Şubesi veriyoruz.
  final yonetici =
      KlinikYoneticisi(subeAdi: "Softito Bağcılar Şubesi");



  //danışanları oluşturalım

  //Danisan classından d1 adında ilk danışan nesnesini oluşturuyoruz.
  final d1 = Danisan(

    //constructor içinde required olan bilgileri giriyoruz.
    id: "DAN-101",
    adSoyad: "Ahmet Yılmaz",
    telefon: "0555 555 55 55",

    //bu danışanı vip üye olarak belirliyoruz.
    vipUyeMi: true,

    //danışanın alerjilerini List olarak giriyoruz.
    alerjiler: ["Retinol,Aspirin"],

    //özel cilt notunu giriyoruz.
    ozelCiltNotu: "Cilt bariyeri hassas",
  );


  //ikinci danışanı oluşturuyoruz.
  final d2 = Danisan(
    id: "DAN-102",
    adSoyad: "Ahmet Yılan",
    telefon: "0555 555 55 55",

    //vip olmadığı için false veriyoruz.
    vipUyeMi: false,

    //alerjisi olmadığı için boş liste veriyoruz.
    alerjiler: [],
  );


  //üçüncü danışanı oluşturuyoruz.
  final d3 = Danisan(
    id: "DAN-103",
    adSoyad: "Mehmet Yılmaz",
    telefon: "0555 555 55 55",
    vipUyeMi: true,
    alerjiler: ["Retinol,Aspirin"],
  );


  //dördüncü danışanı oluşturuyoruz.
  final d4 = Danisan(
    id: "DAN-104",
    adSoyad: "Ahmet Mehmet Yılmaz",
    telefon: "0555 555 55 55",
    vipUyeMi: true,
    alerjiler: [],
    ozelCiltNotu: "Cilt bariyeri hassas",
  );



  //oluşturduğumuz danışanları yöneticinin rehberine kaydediyoruz.
  yonetici.danisanKaydet(d1);
  yonetici.danisanKaydet(d2);
  yonetici.danisanKaydet(d3);
  yonetici.danisanKaydet(d4);


  //ilk iki danışanın bilgi özetlerini ekrana yazdırıyoruz.
  print("Danışan güvenlik kontrolü");

  print(d1.bilgiOzeti);
  print(d2.bilgiOzeti);

  print("----------------------------------");



  //randevular oluşturuluyor

  //SeansKaydi classından ilk randevuyu oluşturuyoruz.
  final seans1 = SeansKaydi(

    //seansın kendine özel kodunu belirliyoruz.
    seansKodu: "SNS-2026-1",

    //bu randevunun d1 danışanına ait olduğunu belirtiyoruz.
    danisan: d1,

    //işlem kategorisini enum içinden seçiyoruz.
    kategori: HizmetKategorisi.Lipo,

    //yapılacak işlemin adını giriyoruz.
    islemAdi: "Lipo gerisini bilmiyorum",

    //bir seansın fiyatını giriyoruz.
    birimFiyat: 6500.0,

    //toplam 2 seans yapılacağını belirtiyoruz.
    seansSayisi: 2,

    //normal %5 indirim uyguluyoruz.
    //d1 vip olduğu için hesaplama sırasında ekstra %10 da eklenecek.
    indirimOrani: 5.0,

    //seanstan sorumlu uzmanı belirliyoruz.
    sorumluUzman: "Sümeyye Arab",
  );


  //ikinci randevuyu oluşturuyoruz.
  final seans2 = SeansKaydi(
    seansKodu: "SNS-2026-2",
    danisan: d2,
    kategori: HizmetKategorisi.ciltYenileme,
    islemAdi: "Siverex ile yüz temizleme",
    birimFiyat: 2500.0,
    seansSayisi: 5,
    indirimOrani: 15.0,

    //bu seansa henüz uzman atanmadığı için null veriyoruz.
    sorumluUzman: null,
  );


  //üçüncü randevuyu oluşturuyoruz.
  final seans3 = SeansKaydi(
    seansKodu: "SNS-2026-3",
    danisan: d3,
    kategori: HizmetKategorisi.lazerEpilasyon,
    islemAdi: "Tüm Vücut",
    birimFiyat: 25000.0,
    seansSayisi: 15,
    indirimOrani: 0.0,
    sorumluUzman: "Tuba Aydın",
  );


  //dördüncü randevuyu oluşturuyoruz.
  final seans4 = SeansKaydi(
    seansKodu: "SNS-2026-4",
    danisan: d4,
    kategori: HizmetKategorisi.medikalEstetik,
    islemAdi: "Burun Estetiği",
    birimFiyat: 1500.0,
    seansSayisi: 3,
    sorumluUzman: "Alaaddin Odabaşı",
  );



  //oluşturduğumuz seansları yöneticinin seans listesine ekliyoruz.
  yonetici.randevuOlustur(seans1);
  yonetici.randevuOlustur(seans2);
  yonetici.randevuOlustur(seans3);
  yonetici.randevuOlustur(seans4);

  print("Seanslar Gönderiliyor");



  //seans 1 başarıyla tamamlanıyor (kredi kartı ile ödeme);

  //seansiTamamla metoduna hangi seansın tamamlandığını
  //ve hangi ödeme yönteminin kullanıldığını gönderiyoruz.
  yonetici.seansiTamamla(
    seansKodu: "SNS-2026-1",
    odeme: OdemeYontemi.krediKarti,
  );


  //seans 2 başarıyla tamamlanıyor (nakit ödeme);

  yonetici.seansiTamamla(
    seansKodu: "SNS-2026-2",
    odeme: OdemeYontemi.nakit,
  );


  //seans 4 iptal ediliyor

  //seansiIptalEt metoduna iptal edilecek seansın kodunu
  //ve iptal nedenini gönderiyoruz.
  yonetici.seansiIptalEt(
    "SNS-2026-4",
    iptalNedeni:
        "Danışanın şehir dışından tanıdığı geldiği için gelemedi",
  );


  //en son gün sonu raporunu ekrana yazdırıyoruz.
  yonetici.gunSonuRaporuYazdir();
}