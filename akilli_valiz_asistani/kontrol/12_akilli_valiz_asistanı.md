# Akıllı Valiz Asistanı

## 1. Proje Özeti
Seyahat süresine, gidilecek yerin hava durumuna ve seyahat türüne (iş, tatil, kamp) göre otomatik bavul hazırlama listesi oluşturan asistan.

## 2. Proje Amacı
Seyahat öncesi hazırlık stresini azaltmak, kritik eşyaların (pasaport, şarj aleti, ilaç) unutulmasını kesin olarak önlemek.

## 3. Tahmini Ekran ve Sayfa Sayısı
3-5 Ekran (Seyahat Planı Oluşturma, Akıllı Öneri Listesi, Valiz Hazırlık Kontrol Ekranı, Özel Eşya Şablonları Yönetimi)

## 4. Temel Özellikler
- Gidilecek destinasyona ve gün sayısına göre dinamik öneri motoru\n- Hava durumu bazlı kıyafet tavsiyesi\n- Ağırlık ve hacim tahmini / kabin bagajı kuralları kontrolü\n- Hazırlanan eşyaları tek tıkla işaretleme

## 5. Hedef Kitle
Genel kullanıcılar, öğrenciler veya ilgili alan profesyonelleri.

---

## 6. Öğrenci Çalışma ve Detay Alanı

### 6.1. Kullanılacak Teknolojiler & Kütüphaneler
- **Uygulama Adı:** PackPilot
- **Frontend:** Flutter 3.47+ (Dart 3.13+) — Web, iOS, Android, Desktop
- **Tasarım Dili:** Material 3, Dark & Light Mode, Glassmorphic Modern UI, Google Fonts (Outfit / Inter)
- **Mimari & State:** Feature-Based Clean Architecture (View, Controller, Model, Repository, Widget), ValueNotifier + ValueListenableBuilder
- **Navigasyon:** go_router (Dinamik yönlendirme & parametre yönetimi)
- **Backend / Veri Depolama:** Supabase mimarisi & LocalStorage (SharedPreferences kalıcı veri katmanı)
- **Ek Kütüphaneler / API'ler:** Open-Meteo Geocoding & Forecast API (Canlı ve saatlik hava durumu), dio (HTTP client), intl (Tarih ve zaman biçimlendirme), uuid

### 6.2. Sayfa Hiyerarşisi ve Akış Planı
- [x] Sayfa 1: **Giriş & Kayıt Ekranı (Auth)** - Misafir girişi, hesap oluşturma ve profil seçimi
- [x] Sayfa 2: **Ana Ekran (Home)** - Güncel Valizim özeti, aktif seyahat sayaçları, hızlı aksiyon menüsü
- [x] Sayfa 3: **Seyahat Planlama (Trip Planner)** - Başlangıç/bitiş takvimi, popüler & arama destekli lokasyon seçimi, varış/ayrılış saatleri
- [x] Sayfa 4: **Seyahat Ajandası & Hava Durumu (Weather Agenda)** - Saatlik ve günlük hava durumu, yağış & sıcaklık tahminleri
- [x] Sayfa 5: **Seyahat Türü & Alt Tür Seçimi (Trip Type)** - İş Gezisi, Kamp, Tatil, Kültürel Gezi ve dinamik alt türler
- [x] Sayfa 6: **Akıllı Öneri Ekranı (Recommendations)** - Hava durumuna ve aktivite türüne göre kıyafet & hazırlık önerileri
- [x] Sayfa 7: **Eşya Listesi Oluşturma (Packing List)** - Standart ve dinamik kategoriler, özel eşya ekleme ve miktar yönetimi
- [x] Sayfa 8: **Valiz Ağırlık ve Hacim Analizi (Luggage Analysis)** - Tahmini kg ve L hesabı, kabin bagajı limit uyarıları
- [x] Sayfa 9: **Valiz Hazırlık Kontrol Ekranı (Checklist)** - "Hazırlanacaklar" ve "Alınanlar" sepetleri, tek tıkla işaretleme, "Ekle Aktivite", "Bitti"
- [x] Sayfa 10: **Ajandam & Profil (Agenda & Profile)** - Geçmiş/Güncel/Gelecek seyahatler, Alışveriş listesi, İsteğe bağlı adet döngüsü takibi, tema ve bildirim ayarları

### 6.3. Veri Modeli ve Bileşen Tasarımı
- **TripModel:** Seyahat id, lokasyon, koordinatlar, tarihler, varış/ayrılış saatleri, seyahat türü ve alt türü
- **WeatherForecastModel:** Günlük ve saatlik sıcaklık, hava durumu kodu, yağış olasılığı, rüzgar hızı
- **PackingItemModel:** Eşya id, ad, kategori, adet, tahmini birim ağırlık (kg), tahmini birim hacim (L), isPacked (alındı mı)
- **ShoppingItemModel:** Alışveriş eşyası, kategori, fiyat tahmini, satın alındı durumu
- **CycleTrackingModel:** Döngü başlangıç tarihi, ortalama döngü süresi, seyahat çakışma riski analizi
- **UserProfileModel:** Kullanıcı adı, e-posta, tema tercihi, bildirim tercihleri

### 6.4. Proje Takvimi ve Teslim Aşamaları
- **Aşama 1 (Tasarım & Wireframe):** Material 3 paleti, PackPilot logo ve ikon varlıkları, tema sistemi oluşturuldu.
- **Aşama 2 (Temel Fonksiyonlar & Arayüz):** Feature-based mimariyle tüm ekranlar, controller yapıları, modeller ve servisler kodlandı.
- **Aşama 3 (Test & İyileştirme):** Birim testler, statik kod analizi (flutter analyze) ve Chrome Web üzerinde doğrulama tamamlandı.
- **Aşama 4 (Final Teslim):** Dokümantasyon (`GELISTIRME_TAKIP.md`, `project.md`) ve çalışan Chrome web sunumu teslim edildi.

### 6.5. Notlar & Karşılaşılan Zorluklar
- Open-Meteo API'sinden gelen saatlik hava durumu verilerinin varış ve ayrılış saat aralıklarına göre filtrelenmesi sağlandı; internet bağlantısı olmaması durumuna karşı akıllı fallback mekanizması eklendi.
- ValueNotifier mimarisi ile sayfa düzeyinde gereksiz setState çağrıları engellendi, reaktif ve yüksek performanslı bir kullanıcı deneyimi elde edildi.
- Eşyaların ağırlık ve hacim referans tablosu oluşturularak valiz aşımı durumunda kullanıcıya görsel kabin bagajı uyarı kartı sunuldu.
