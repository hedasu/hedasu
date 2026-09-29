
// Set ve ağ güvenlik kümeleri
void main(){
  print("Beyaz Liste ve Küme Analizi");

  final Set<String> istanbulVeriMerkeziIpleri={
    "10.0.1.10",
    "10.0.1.11",
    "10.0.1.12",
    "10.0.1.13",
    "10.0.1.10", // çift kayıt set burayı anınnda tek hale getirir
  };
  print("İstanbul Ipleri: $istanbulVeriMerkeziIpleri");

  final Set<String> frankfurtVeriMerrkziIpleri={
    "10.0.1.13",
    "10.0.1.30",
    "10.0.1.45",
  };

  print("Frankfurt Ipleri: $frankfurtVeriMerrkziIpleri");

  final ortakKopruIpler=istanbulVeriMerkeziIpleri.intersection(frankfurtVeriMerrkziIpleri);
  print("Ortak Ağ Ipleri(kesişim): $ortakKopruIpler");


  final tumGlobalIpler=istanbulVeriMerkeziIpleri.union(frankfurtVeriMerrkziIpleri);
  print("Toplam Globl Ipler(birleşim):$tumGlobalIpler");


  final sadeceIstanbul=istanbulVeriMerkeziIpleri.difference(
    frankfurtVeriMerrkziIpleri,
  );
  print("Sadece İstanbul : $sadeceIstanbul");






}