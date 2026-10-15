typedef MetrikUyariKurali=bool Functioonn(double deger);

void metrikDenetle({
  required String metrikAdi,
  required double mevcutDeger,
  required MetrikUyariKurali kural,
  required void Function(String mesaj) alertTetikleyici,
}) {
  if (kural(mevcutDeger)){
    alertTetikleyici(
      "Uyarı:$metrikAdi eşik değerini aştı.
      Mevcut:$mevcutDeger",
    );
  } else {
    print("$metrikAdi normal sınırlar içinde ($mevcutDeger)");
  }
}



void main(){
  print("Metrik Uyarıları");
  final MetrikUyariKurali yuksekCpu=(deger) => deger >= 85.0;
  final MetrikUyariKurali yuksekRam= (deger) => deger >= 90.0;


  metrikDenetle(metrikAdi: "Cpu", mevcutDeger: 64.0, kural: kur, alertTetikleyici: alertTetikleyici)







}