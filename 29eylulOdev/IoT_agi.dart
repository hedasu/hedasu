enum CihazTipi {
  sensor,
  gateway,
  edgeServer,
  router
}

// Özel Exception sınıfı
class CihazErisilemezException implements Exception {
  final String mesaj;

  CihazErisilemezException(this.mesaj);

  @override
  String toString() => mesaj;
}

// IoT cihaz sınıfı
class IoTCihaz {
  final String seriNo;
  final String cihazAdi;
  final CihazTipi tip;
  final double cpuYukYuzdesi;
  final int bellekMb;
  final Set<String> acikPortlar;
  final bool sslSertifikasiGecerliMi;
  final bool acikMi;

  const IoTCihaz({
    required this.seriNo,
    required this.cihazAdi,
    required this.tip,
    required this.cpuYukYuzdesi,
    required this.bellekMb,
    required this.acikPortlar,
    this.sslSertifikasiGecerliMi = true,
    this.acikMi = true,
  });

  // Güvenlik açığı kontrolü
  bool get guvenlikAcigiVarMi =>
      !sslSertifikasiGecerliMi ||
      acikPortlar.contains("23");
}


// Cihaz tipine göre izolasyon bölgesi
// Dart 3 Switch Expression
String izolasyonBolgesi(CihazTipi tip) {
  return switch (tip) {
    CihazTipi.sensor => "ZONE-S",
    CihazTipi.gateway => "ZONE-G",
    CihazTipi.edgeServer => "ZONE-E",
    CihazTipi.router => "ZONE-R",
  };
}


// Seri numarasına göre cihaz bulma
// Dart 3 Record
({String cihazAdi, CihazTipi tip, bool alarmDurumu})? cihazBul(
  List<IoTCihaz> cihazlar,
  String seriNo,
) {
  for (var cihaz in cihazlar) {
    if (cihaz.seriNo == seriNo) {
      return (
        cihazAdi: cihaz.cihazAdi,
        tip: cihaz.tip,
        alarmDurumu:
            cihaz.guvenlikAcigiVarMi ||
            cihaz.cpuYukYuzdesi > 85,
      );
    }
  }

  // Seri numarası bulunamazsa null döndür
  return null;
}


// Cihaza erişim kontrolü
void cihazaEris(IoTCihaz cihaz) {
  if (!cihaz.acikMi) {
    throw CihazErisilemezException(
      "${cihaz.cihazAdi} cihazina erisilemiyor. Cihaz kapali.",
    );
  }

  print("${cihaz.cihazAdi} cihazina basariyla erisildi.");
}


void main() {

  // IoT cihazlarının oluşturulması
  final List<IoTCihaz> cihazlar = [

    IoTCihaz(
      seriNo: "SN001",
      cihazAdi: "Sicaklik Sensoru",
      tip: CihazTipi.sensor,
      cpuYukYuzdesi: 25.5,
      bellekMb: 512,
      acikPortlar: {"80", "443"},
      sslSertifikasiGecerliMi: true,
    ),

    IoTCihaz(
      seriNo: "SN002",
      cihazAdi: "Ana Gateway",
      tip: CihazTipi.gateway,
      cpuYukYuzdesi: 72.3,
      bellekMb: 2048,
      acikPortlar: {"23", "80", "443"},
      sslSertifikasiGecerliMi: false,
    ),

    IoTCihaz(
      seriNo: "SN003",
      cihazAdi: "Edge Server",
      tip: CihazTipi.edgeServer,
      cpuYukYuzdesi: 88.7,
      bellekMb: 8192,
      acikPortlar: {"80", "443", "8080"},
      sslSertifikasiGecerliMi: true,
    ),

    IoTCihaz(
      seriNo: "SN004",
      cihazAdi: "Fabrika Router",
      tip: CihazTipi.router,
      cpuYukYuzdesi: 45.2,
      bellekMb: 4096,
      acikPortlar: {"23", "443"},
      sslSertifikasiGecerliMi: false,
    ),

    IoTCihaz(
      seriNo: "SN005",
      cihazAdi: "Nem Sensoru",
      tip: CihazTipi.sensor,
      cpuYukYuzdesi: 15.8,
      bellekMb: 256,
      acikPortlar: {"80"},
      sslSertifikasiGecerliMi: true,
    ),

    IoTCihaz(
      seriNo: "SN006",
      cihazAdi: "Yedek Gateway",
      tip: CihazTipi.gateway,
      cpuYukYuzdesi: 63.4,
      bellekMb: 1024,
      acikPortlar: {"23", "8080"},
      sslSertifikasiGecerliMi: false,

      // Bu cihaz kapalı
      acikMi: false,
    ),
  ];


  // WHERE ile riskli cihazları bulma
  final List<IoTCihaz> riskliCihazlar = cihazlar
      .where(
        (cihaz) =>
            cihaz.guvenlikAcigiVarMi ||
            cihaz.cpuYukYuzdesi > 85,
      )
      .toList();

  print("Riskli Cihazlar:");

  for (var cihaz in riskliCihazlar) {
    print(cihaz.cihazAdi);
  }


  // FOLD ile toplam bellek hesaplama
 print("\nCihazlarin Bellek Kullanimi:");

// Her cihazın bellek kullanımını ayrı ayrı yazdırıyoruz.
for (var cihaz in cihazlar) {
  print("${cihaz.cihazAdi} : ${cihaz.bellekMb} MB");
}

// Bütün cihazların belleklerini fold() kullanarak topluyoruz.
final int toplamBellek = cihazlar.fold(
  0,
  (toplam, cihaz) => toplam + cihaz.bellekMb,
);

// Toplam bellek kullanımını yazdırıyoruz.
print("Toplam : $toplamBellek MB");


  // RECORD kullanarak seri numarasına göre cihaz bulma
  var sonuc = cihazBul(cihazlar, "SN003");

  if (sonuc != null) {
    print("\nCihaz Bilgileri:");
    print("Cihaz Adi: ${sonuc.cihazAdi}");
    print("Cihaz Tipi: ${sonuc.tip}");
    print("Alarm Durumu: ${sonuc.alarmDurumu}");
  } else {
    print("Bu seri numarasina ait cihaz bulunamadi.");
  }


  // SWITCH EXPRESSION ile izolasyon bölgelerini gösterme
  print("\nCihaz Izolasyon Bolgeleri:");

  for (var cihaz in cihazlar) {
    print(
      "${cihaz.cihazAdi}: ${izolasyonBolgesi(cihaz.tip)}",
    );
  }


  // TRY-CATCH ile kapalı cihaza erişim
  try {
    cihazaEris(cihazlar[5]);
  } on CihazErisilemezException catch (e) {
    print("Hata: $e");
  }
}