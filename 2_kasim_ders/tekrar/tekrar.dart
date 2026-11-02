// MÜLAKAT İÇİN ÖNEMLİ: Sealed sınıflar dışarıdan extend edilmez.Switch içinde tüm alt sınıflar tüketilmek zorundadır.
// içindeki fonksiyonları tüketmeye çalışır.Bitmezse döngüye girer. döngü belleğe tüketene kadar devam eder.

sealed class OdemeDurumu {}

class OdemeBasarili extends OdemeDurumu {
  final ({String referansKodu, double tutar}) veri;
  OdemeBasarili(this.veri);
}

class OdemeBasarisiz extends OdemeDurumu {
  final String hataNedeni;
  OdemeBasarisiz(this.hataNedeni);
}

//Bunlar durum classları. Bu yüzden yazdığımızı bize fonksiyon ile verir.

abstract class IBankaServisi {
  Future<OdemeDurumu> odeme({required double miktar});
}

//mixin:bir fonksiyona ya da classa başka bir fonk./classtan yetenek kazandırma

mixin GuvenlikDenetimMixin {
  bool tokenGecerliMi(String token) {
    return token.isNotEmpty && token.length >= 32;
  }
}

mixin AuditLogMixin {
  void islemKaydet(String mesaj) {
    final zaman = DateTime.now().toIso8601String();
    print('Log - $zaman: $mesaj');
  }
}

class GarantiBankasiServisi
    with GuvenlikDenetimMixin, AuditLogMixin
    implements IBankaServisi {
  final String apiAnahtari;

  GarantiBankasiServisi({required this.apiAnahtari});

  @override
  Future<OdemeDurumu> odeme({required double miktar}) async {
    if (!tokenGecerliMi(apiAnahtari)) {
      islemKaydet('Ödeme reddedildi.Geçersiz api anahtarı');
      return OdemeBasarisiz('Geçersiz token');
    }

    await Future.delayed(const Duration(milliseconds: 1000));

    islemKaydet(
      '$miktar tutarındaki ödeme Garanti Bankası tarafından ONAYLANDI',
    );

    return OdemeBasarili((
      referansKodu: 'GRNT-${DateTime.now().millisecondsSinceEpoch}',
      tutar: miktar,
    ));
  }
}

void odemeSonucunuEkranaBas(OdemeDurumu durum) {
  final mesaj = switch (durum) {
    OdemeBasarili b =>
      'Ödeme Başarılı.Ref:${b.veri.referansKodu} Tutar:${b.veri.tutar} ₺',
    OdemeBasarisiz b => 'Ödeme Başarısız. Gerekçe :${b.hataNedeni} ',
  };
  print(mesaj);
}

// tutar,apianahtarı girilecek
void main() async {
  final double tutar = 355.99;
  final String apiAnahtari =
      "abcdefghijklmnoprstuvwyzojıorjufoıjrjrgeoıjrgoıjh"; //32den az olduğunda hata
  final garantiBankasi = GarantiBankasiServisi(apiAnahtari: apiAnahtari);
  final sonuc = await garantiBankasi.odeme(miktar: tutar);

  odemeSonucunuEkranaBas(sonuc);
}
