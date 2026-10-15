class SunucuMetrigi {
  final String hostAdi;
  final String bolge;
  final double cpuYuzesi;
  final double ramGb;
  final int aktifBaglantiSayisi;
  final bool kritikMi;

const SunucuMetrigi({
  required this.hostAdi,
  required this.bolge,
  required this.cpuYuzdesi,
  required this.ramGb,
  required this.aktifBAglantiSayisi,
  required this.kritikMi = false,
});

@override 
String toString() =>
    "$hostAdi [$bolge] (CPU: %$cpuYuzdesi, Ram:${ramGb}GB, Conn: $aktifBaglantiSayisi)";
}


void main(){
  print("")











// fold() ile toplam aktif trafik gösterimi
  final int toplamBaglantiSayisi=sunucuKumesi.fold(
    0,
    (toplam,sunucu) => toplam + sunucu.
    aktifBaglantiSayisi,
  );
  print("Toplam Bağlantı: $toplamBaglantiSayisi");
  //every() ve any()
  final bool tumSunucularCalisiyorMu=sunucuKumesi.every((s)=>.ramGb>=8.0);
  final bool tehlikeliSunucuVarMi=sunucuKumesi.any((s)=>s.cpuYuzdesi>=90.0);
  print("Tüm sunucularınn Ram'i en az 8 gb mı? : $
  

  final euWestSunucular









} 