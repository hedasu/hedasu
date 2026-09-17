class Urun {
    String id;
    String ad;
    double fiyat;
    int stok;

    Urun(this.id , this.ad , this.fiyat , this.stok );
}

class DijitalUrun extends Urun {
  DijitalUrun(
    super.id,
    super.ad,
    super.fiyat,
    super.stok,
  );
}

class FizikselUrun extends Urun {
  FizikselUrun(
    super.id,
    super.ad,
    super.fiyat,
    super.stok,
  );

  double kargoUcretiHesapla();
  return 29.90;
}

abstract class ISiparisIslemleri {
  void siparisKaydet(String orderId, double tutar);
}

class SiparisServisi implements ISiparisIslemleri {
  SqliteVeritabani db = SqliteVeritabani();

  @override
  void siparisKaydet(String orderId, double tutar) {
    db.kaydet(
      "INSERT INTO siparisler VALUES ('$orderId', '$tutar')",
    );
  }
}

abstract class IOdemeIslemleri {
  void odemeYap(String tip, double tutar);
}

class OdemeServisi implements IOdemeIslemleri {
  @override
  void odemeYap(String tip, double tutar) {
    if (tip == "KREDI_KARTI") {
      print("$tutar TL kredi kartından POS ile çekildi.");
    } else if (tip == "HAVALE") {
      print("$tutar TL havale kontrol edildi.");
    } else if (tip == "KAPIDA_ODEME") {
      print("$tutar TL kapıda ödeme tahsil edilecek.");
    } else if (tip == "CRYPTO") {
      print("$tutar TL USDT transferi onaylandı.");
    } else {
      print("Geçersiz ödeme yöntemi");
    }
  }
}

abstract class IKargoIslemleri {
  void kargoGonder(String orderId, String adres);
}

class KargoServisi implements IKargoIslemleri {
  @override
  void kargoGonder(String orderId, String adres) {
    print("MNG Kargo takip fişi basıldı: $adres");
  }
}

abstract class IBildirimIslemleri {
  void mailGonder(String email, String mesaj);
  void smsGonder(String tel, String mesaj);
}

class BildirimServisi implements IBildirimIslemleri {
  SmtpMailServisi mailci = SmtpMailServisi();
  NetgsmSmsServisi smsci = NetgsmSmsServisi();

  @override
  void mailGonder(String email, String mesaj) {
    mailci.mailGonder(email, mesaj);
  }

  @override
  void smsGonder(String tel, String mesaj) {
    smsci.smsYolla(tel, mesaj);
  }
}

abstract class IFaturaIslemleri {
  void faturaYazdir(String orderId);
}

class FaturaServisi implements IFaturaIslemleri {
  @override
  void faturaYazdir(String orderId) {
    print("Fatura PDF çıkarıldı: $orderId");
  }
}

 void siparisTamamla(
      String orderId,
      List<Urun> sepet,
      String odemeTipi,
      String musteriAdi,
      String email,
      String tel,
      String adres,
      String kuponKodu) {
    
    double toplam = 0;

    for (var i = 0; i < sepet.length; i++) {
      if (sepet[i].stok <= 0) {
        print("Hata: " + sepet[i].ad + " tukenmis!");
        return;
      }
      toplam += sepet[i].fiyat;
      toplam += sepet[i].kargoUcretiHesapla();
      sepet[i].stok--;
    }

    if (kuponKodu == "INDIRIM10") {
      toplam = toplam * 0.90;
    } else if (kuponKodu == "YAZ20") {
      toplam = toplam * 0.80;
    } else if (kuponKodu == "SEPETTE50") {
      toplam = toplam - 50;
    }

    double kdv = toplam * 0.20;
    double sonTutar = toplam + kdv;

    odemeYap(odemeTipi, sonTutar);
    siparisKaydet(orderId, sonTutar);
    faturaYazdir(orderId);
    mailGonder(email, "Sayin $musteriAdi, siparisiniz alindi. Tutar: $sonTutar TL");
    smsGonder(tel, "Siparisiniz onaylandi: $orderId");
    kargoGonder(orderId, adres);
  }
}
void main() {
  var siparisci = SiparisYoneticisi();

  var urun1 = FizikselUrun("1", "Kablosuz Mouse", 450.0, 5);
  var urun2 = DijitalUrun("2", "Flutter Kursu E-Kitap", 150.0, 100);

  var sepet = <Urun>[urun1, urun2];

  siparisci.siparisTamamla(
    "SP-9921",
    sepet,
    "KREDI_KARTI",
    "Selahaddin",
    "selahaddin@kodvance.com",
    "05551112233",
    "Kadikoy / Istanbul",
    "INDIRIM10",
  );
}