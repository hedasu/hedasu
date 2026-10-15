class hazineKasasi {
  final int altinMiktari;
  double _hazine = 0.0;

  hazineKasasi({
    required this.altinMiktari,
  });

  double get hazine {
    return _hazine;
  }

  set hazine(double yeniAltin) {
    if (yeniAltin <= 0.0) {
      _hazine = 0.0;
      print("!UYARI: Sahte para eklenemez!");
    } else {
      _hazine = yeniAltin;
    }
  }
}

void main() {
  print("Hazine Kasasi");

  final kasa = hazineKasasi(
    altinMiktari: 100,
  );

  print("Kasaya 100 Altın Eklendi");

  kasa.hazine = 100.0;

  print("Kasadaki Hazine : ${kasa.hazine} Altın");

  kasa.hazine = -50.0;

  print("Nihai Hazine    : ${kasa.hazine} Altın");
}