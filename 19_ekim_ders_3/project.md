# Fitness Su takip uygulaması
Bu doküman flutter projesinde geliştirme yapacak olan Ajan (antigravity) yapay zeka ve yazılşım geliştiriciler için bağlayıcı bir kılavuzdur.Projede yazılan her kod satırı buradaki kurallara UYMAK ZORUNDADIR

##1. Proje Özeti ve Teknolojiler
-**Uygulama Adı:** Susadım (akıllı su egzersiz ve kalori takibi uygulaması) 

-**Hedef Platformlar:** İos ve android öncelikli ardından web ve masaüstü platformları

- **Flutter SDK:**  3.29.0

- **Dart SDK:** 3.0.0

- **Tasarım Dili:** Material 3, Dinamik Tema Desteği: Koyu tema (gece spor salonu paketi, dark obsidian & neon) ve Aydınlık tema (ferah spor salonu paketi, temiz beyaz & neon vurgular). Kullanıcı tek dokunuşla dinamik tema geçişi yapabilir.

- **Eklenen Özellikler:** Eklenen her bir etkinlik için geri alma tuşu olsun (su ve fitness). Hedefler tamamlandığında (su takibi ve egzersiz) rozet kazanılsın. Kazanılan rozetleri görebileceğimiz bir bölüm olsun (yeni bir modül olarak). **Karanlık ve Aydınlık mod geçişi** (AppBar üzerinden reaktif geçiş).
---


## Mimari Yapı : Özellik Bazlı
kodlar kesinlikle tek bir yerde toplanmayacaktır.Her modül kendi feature klasöründe olmalıdır.

```text
lib/
core/
extension/
        constans/app_colors.dart
        theme/app_theme.dart

    feautures
        water_traker/
            controller/
            models/
            view/
            widget/
        workout/
            controller/
            models/
            view/
            widget/
        

    main.dart
```

# sadece uygulama başlatma ve tema bölümleri


## 3. Kırmızı Çizgiler Kod Kalite Standartları
1- **State Yönetim Standartları:**
Sayfa düzeyinde ağır `setState` KULLANILMAYACAKTIR.
Sadece yerel arayüz durumunu yöneten (örneğin buton animasyonları vb.) StatefulWidget kabul edilir.

2- **UI ve Performans Kuralları:**
Statik tüm widget'larda `const` zorunludur.
Renk ve metin stilleri kesinlikle tema dosyalarına yazılacaktır.
Büyük build methodları yasaktır 40 satırı geçen build methodları özel widgetlara yazılacaktır.

3- **Yasaklı Paketler:**
Projeye onay almadan harici ağır state paketleri EKLENMEYECEKTİR.
Dart'ın ve Flutter'ın yerel çekirdek apilerini kullanmak esastır.

## 4. Geliştirme Analiz ve Test Komutları
Ajan yaptığı herhangi bir kod değişikliklerinden sonra mutlaka alttaki komutların çalıştığını doğrulamalıdır.

* **Statik Kod Analizi(0 uyarı ve 0 hata şart):**
```bash
flutter analyze
```

* **Bİrim ve Widget testleri:**
```bash
flutter test
```

* **Projeyi Çalıştırma:**
```bash
flutter run
```


## 5. Ajanın Çıktı ve Yanıt Verme Standartları

**Açıklamalar:** Türkçe teknik terimlerin özünü bozmadan net ve doğrudan olacaktır.
**Değişiklik Sunumları:** Örnek 500 satırlık bir dosyada 3 satır değiştiyse tüm dosyayı baştan sona basma; hedef satırları ve diff yapısını göster
**Dosya Yolları:** Bahsedilen ve üretilen her dosya için mutlaka projeye tıklanabilir link ver.
**Doğrulama:** Kod yazdıktan sonra kullanıcıya "Şimdi flutter analiz ile kontrol edebilirsin" şeklinde doğrulama yönergeleri ver.




