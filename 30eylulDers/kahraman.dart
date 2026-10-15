class Kahraman {
  final String ad;
  final String sinif;
  int seviye;
  double saldiriGucu;
  bool hayattaMi;

  // Normal constructor
  Kahraman({
    required this.ad,
    required this.sinif,
    this.seviye = 1,
    this.saldiriGucu = 50.0,
    this.hayattaMi = true,
  });

  // Named constructor
  Kahraman.acemi({
    required this.ad,
  })  : sinif = "Çırak Savaşçı",
        seviye = 1,
        saldiriGucu = 25.0,
        hayattaMi = true;

  // Factory constructor
  factory Kahraman.fromSaveJson(Map<String, dynamic> json) {
    return Kahraman(
      ad: json["ad"] as String,
      sinif: json["sinif"] as String,
      seviye: json["seviye"] as int,
      saldiriGucu: (json["hasar"] as num).toDouble(),
      hayattaMi: json["hayatta"] as bool,
    );
  }

  // Kahramanın bilgilerini ekrana yazdıran metot
  void kartiYazdir() {
    print(
      "[$sinif] $ad | Seviye: $seviye | Güç: $saldiriGucu | Durum: ${hayattaMi ? 'Canlı' : 'Ruh Halinde'}",
    );
  }
}

void main() {
  print("Karakter Üretimi");

  // Normal constructor ile karakter oluşturma
  final sampiyon = Kahraman(
    ad: "Tuba Aydın",
    sinif: "Şövalye",
    seviye: 10,
    saldiriGucu: 120.0,
  );

  sampiyon.kartiYazdir();

  // Named constructor ile acemi karakter oluşturma
  final caylak = Kahraman.acemi(
    ad: "Furkan Çalışkan",
  );

  caylak.kartiYazdir();

  // JSON'dan gelecek karakter bilgileri
  final Map<String, dynamic> jsondanGelenKarakter = {
    "ad": "Alaaddin",
    "sinif": "Ak Büyücü",
    "seviye": 50,
    "hasar": 350.5,
    "hayatta": true,
  };

  // Factory constructor ile JSON verisinden karakter oluşturma
  final efsane = Kahraman.fromSaveJson(
    jsondanGelenKarakter,
  );

  efsane.kartiYazdir();
}