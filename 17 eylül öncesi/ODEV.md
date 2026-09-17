# KahveGo Tasarım Ödevi
## Görev 1 - Pseudo Kod
''' text
BAŞLA

Uygulamayı aç

EĞER kullanıcı giriş yapmamış İSE
    Giriş ekranına yönlendir
DEĞİLSE
    Ürünleri göster

    DÖNGÜ kullanıcı ürün seçmeye devam ettiği sürece
        Ürünü seç
        Ürünü sepete ekle
    DÖNGÜ SONU

    Sepet toplamını hesapla

    Kullanıcı siparişi onaylar

    EĞER bakiye >= sepet toplamı İSE
        Sipariş paketini sunucuya gönder
        Bakiyeden sepet toplamını düş
        "Siparişiniz başarıyla oluşturuldu" mesajını göster
    DEĞİLSE
        "Yetersiz bakiye - Bakiye Yükle" uyarısını göster
        Siparişi onaylama
        Sepet ekranına geri dön
    EĞER SONU

EĞER SONU

BİTİR```

## Görev 2 - Endpoint & JSON Tasarımı

### Sipariş Oluşturma Endpoint'i

- **HTTP Metodu:** `POST`
- **URL / Endpoint:** `/api/v1/siparisler`

- **Header:**
  - `Authorization: Bearer <token>`
  - `Content-Type: application/json`

- **Örnek Request Body (JSON):**

```json
{
  "urun": "Latte",
  "boyut": "Orta",
  "adet": 2,
  "toplam_tutar": 240.00
}
```

### Cüzdan Bakiye Sorgulama Endpoint'i

- **HTTP Metodu:** `GET`
- **URL / Endpoint:** `/api/v1/kullanici/bakiye`

- **Örnek Response (JSON):**

```json
{
  "bakiye": 185.50,
  "para_birimi": "TRY"
}
```

### Mİni Mülakat
```text
Idompotent : aynı istek tekrarlandığında sistemde değişiklik oluşmaması durumudur. Yukarıdaki http metodlarından post metodu her seferinde farklı bir veri kaydeder ancak get metodu var olan verilerden çağırır. Bu yüzden get metodu idompotent metottur. 
```

## Görev 3 - Clean Code & SOLID Prensip Teşhisi

### SRP Ihlali ve Düzeltme Önerisi

```dart
class KahveSiparisYoneticisi {
void sepetHesaplaVeIndirimUygula() { ... }
void krediKartindanTahsilatYap() { ... }
void siparisiVeritabaninaKaydet() { ... }
void musteriyiSmsIleBilgilendir() { ... }
double indirimHesapla(String musteriTipi, double tutar) {
if (musteriTipi == "OGRENCI") return tutar * 0.80;
else if (musteriTipi == "OGRETMEN") return tutar * 0.85;
else return tutar;
}
}
```

```text
SRP prensipi bir sınıfın tek işlem yürütmesi gerektiğini savunan prensiptir.
Yukarıdaki sınıf örneği indirim ,ödeme ,kayıt tutma ,müşteri bilgilendirme gibi birden fazla işi yapmakta. Bu durum da SRP ye aykırıdır.

Düzeltmek için ayrı bir göreve hizmet eden fonksiyonlar ayrılmalı ki bu örnekte hepsi ayrı bir görevde (örneğin müşteri bilgilendirme sms ve maille yapılıyor olsaydı aynı sınıfta yer alırlardı).
```

### SOLID İhlali Bulma
```dart
double indirimHesapla(String musteriTipi, double tutar) {
if (musteriTipi == "OGRENCI") return tutar * 0.80;
else if (musteriTipi == "OGRETMEN") return tutar * 0.85;
else return tutar;
}
}
```
```text
Bu fonksiyona doktor vb. gibi yeni müşteri tipi eklemek istediğimizde sürekli elmizdeki kodu değiştirmemiz gerekecek.Bu durum da OCP ye aykırıdır. OCP yeni özellik eklenmesini destekliyor ama içindeki kodun değiştirilmesi ihlale giriyor.
```


