otoVia — Tasarım Sistemi ve Stil Rehberi
Durum: Tasarım yönü seçildi, nihai görsel onay bekleniyor.
Sürüm: 1.0 (taslak)
Teknoloji: Flutter / Material Design 3
Konsept: Monochrome Luxury + Editorial Layout (A)
Dil: Türkçe

1. Tasarım Vizyonu
otoVia, motosiklet, binek otomobil, SUV, geniş grup aracı ve nakliye aracı kiralama deneyimini minimalist, zarif, modern ve güven veren bir arayüzle sunar. Stil, lüks otomobil kataloglarının görsel ferahlığı ile iyi yapılandırılmış bir mobil uygulamanın işlevselliğini birleştirir.
Not: Marka adı her yerde tam olarak otoVia yazılmalıdır. (Büyük/küçük harf duyarlılığına dikkat.)

Temel ilkeler:
- İçerik önceliği: Araç fotoğrafları, kiralama fiyatı ve rezervasyon aksiyonu kolayca görülür.
- Editorial Layout: Mobil araç listeleri tek sütunlu, geniş ve fotoğraf odaklı kartlardan oluşur.
- Görsel sadelik: Yalnızca gerekli bilgiler gösterilir; ayrıntılar araç detay sayfasına bırakılır.
- Tutarlılık: Sayfalar ortak Material 3 tema token'larını ve bileşen stillerini kullanır.
- Kontrast ve erişilebilirlik: Bilgi yalnızca renkle aktarılmaz; yazılar okunabilir, dokunmatik hedefler erişilebilirdir.
- Nötr renkler: Neon, yoğun degrade, agresif gölgeler ve aşırı dekoratif efektler kullanılmaz.
2. Tasarım Altyapısı ve Tema Davranışı
- Flutter ThemeData ve ColorScheme tabanlı Material Design 3 (useMaterial3: true) kullanılacak.
- İki açıkça tanımlanmış tema: Ivory White (Light) ve Obsidian Luxury (Dark).
- Ana ekranın AppBar bölümünde güneş/ay simgeli tema değiştirme aksiyonu bulunacak.
- Tema anlık olarak bütün ekranlarda güncellenecek (ThemeMode.light ↔ ThemeMode.dark); sayfalar arası geçişte kaybolmayacak.
- Seçim cihazda kalıcı saklanacak (ör. shared_preferences ile); uygulama yeniden açıldığında geri yüklenecek.
- Tema renkleri tek merkezden (app_theme.dart / tema katmanı) yönetilecek; ekranlara dağılmış sabit renkler kullanılmayacak.
- Bu proje işletim sisteminden rastgele dinamik renk üretmek yerine, marka kimliğini koruyan iki kontrollü tema kullanır. Burada “dinamik tema” kullanıcının anlık tema geçişi anlamındadır.
3. Renk Paleti
3.1 Aydınlık Tema — Ivory White
Tasarım token'ı	HEX	Kullanım
background	#F7F7F5	Ekran zemini (kırık beyaz)
surface	#FFFFFF	Araç kartları, formlar, üst alanlar
surfaceVariant	#EEEEEB	Segmentli kontrol ve ikincil yüzeyler
primary	#1C1C1C	Ana eylem butonu, seçili durum
onPrimary	#FFFFFF	Ana buton üzerindeki yazı/ikon
onSurface	#191919	Başlıklar ve ana metinler
onSurfaceVariant	#62625F	İkincil metinler ve açıklamalar
outline	#DCDCD8	Sınırlar ve ince ayırıcılar
accent	#A79A89	Sınırlı şampanya vurgusu/dekoratif ikon


3.2 Karanlık Tema — Obsidian Luxury
Tasarım token'ı	HEX	Kullanım
background	#141414	Ekran zemini (obsidyen siyahı)
surface	#222222	Araç kartları, formlar, üst alanlar
surfaceVariant	#303030	Segmentli kontrol ve ikincil yüzeyler
primary	#EEEDE9	Ana eylem butonu, seçili durum
onPrimary	#191919	Ana buton üzerindeki yazı/ikon
onSurface	#F5F5F2	Başlıklar ve ana metinler
onSurfaceVariant	#B8B8B2	İkincil metinler ve açıklamalar
outline	#393939	Sınırlar ve ince ayırıcılar
accent	#C0B09A	Sınırlı şampanya vurgusu/dekoratif ikon


Renk kullanım kuralları
1. Temel arayüz monokrom olacak; şampanya tonu küçük ayrıntılarda kullanılacak, uzun metin rengi olmayacak.
2. Fiyat, buton, arama alanı ve müsaitlik bilgisi iki temada da yeterince yüksek kontrastlı olacak.
3. Hata, başarı, uyarı ve bilgi durumları için Material 3 semantik renk rolleri tanımlanacak; yalnızca dekoratif şampanya rengiyle durum ifade edilmeyecek.
4. ColorScheme.fromSeed(...) kullanılacaksa sonrasında marka paleti copyWith ile sabitlenmeli; temel marka renkleri rastlantısal değişmemeli.
5. Nihai uygulamada özellikle küçük yazıların ve ince ikonların kontrastı cihaz üzerinde test edilecek (normal metin için hedef en az 4.5:1).
4. Tipografi
- Genel yaklaşım: Modern, sade, rahat okunan sans-serif.
- Varsayılan olarak Flutter'ın platforma uygun sistem yazı tipini kullan; ayrıca özel font eklenecekse tüm platformlara düzgün tanımlanmalı.
- Büyük başlıklar: 28–30sp, orta/semibold.
- Bölüm başlıkları: 20–22sp, semibold.
- Araç adları: 17–18sp, semibold.
- Normal açıklamalar: 14–16sp, regular.
- Yardımcı bilgi ve etiketler: 12–14sp, yalnızca okunabilir kontrastla.
- Fiyat bilgisi: 18–22sp, semibold; birim (/ saat, / gün) daha küçük ve ikincil renkte.
- Süs için tamamı büyük harfli çok uzun başlıklar ve aşırı ince fontlar kullanılmaz.
- Dinamik sistem yazı ölçeklendirmesinde (text scaling) taşma olmamalı.
5. Boşluk, Köşeler, Kenarlıklar ve Gölge
- 8dp aralıklı boşluk sistemi: 4 / 8 / 12 / 16 / 24 / 32dp.
- Ekranın yatay içerik boşluğu: 16–20dp.
- Ana bölümler arası boşluk: 24–32dp.
- Araç kartının iç boşluğu: 12–16dp.
- Kartlar arası dikey boşluk: 16–20dp.
- Araç kartı köşeleri: 16dp.
- Buton ve giriş alanı köşeleri: 10–12dp.
- Kategori chip'leri: tam oval (StadiumBorder) veya Material 3 uyumlu yumuşak köşeli.
- İnce 1dp sınırlar kullanılabilir; yoğun gölgelerden kaçınılır.
- Yüzeyleri birbirinden ayırmak için önce boşluk ve ton farkı tercih edilir.
6. Ana Sayfa — Editorial Layout A
Mobilde tek sütunlu dikey akış kullanılacak. Önerilen bölüm sırası:
1. AppBar: Sol tarafta otoVia logosu/wordmark; sağ tarafta tema değiştirici ve bildirim simgesi (profil erişimi alt navigasyonda).
2. Karşılama: “Aracını keşfet.” gibi kısa başlık; istenirse tek satırlık açıklama.
3. Araç arama: Marka/model için sade Material 3 SearchBar.
4. Kiralama tipi: SegmentedButton ile Saatlik / Günlük (seçili tipe uygun fiyat etiketleri).
5. Araç kategorileri: Yatay kaydırılabilir FilterChip satırı: Motor, Binek, SUV, Grup, Nakliye.
6. Filtre ve sıralama: Fiyat, yakıt, vites, model yılı, ehliyet sınıfı vb. için giriş; mümkünse ikincil filtreler bottom sheet/dialog içinde.
7. Kiralama amacına göre öneriler: Şehir içi, aile, uzun yol, grup, nakliye için dar ve sade seçim bileşeni; kullanıcı istemedikçe ekranı kaplamasın.
8. Araç listesi: Büyük görselli, tek sütunlu geniş ilan kartları.
9. Aktif kiralama kartı (koşullu): Kullanıcının aktif teslim aldığı aracı, teslim zamanını ve Canlı Destek aksiyonunu ana sayfada görünür tut; aktif kiralama yoksa gösterme.
Araç liste kartı
Üst bölüm: Geniş araç fotoğrafı (yaklaşık 16:9), kartın görsel odak noktası. Görsellerde mümkün olduğunca tek tip kadraj kullan.
Orta bölüm: Marka–model, favori ikonu, kısa satırda kategori / vites / yakıt.
Alt bölüm: Puan, uygun ehliyet sınıfı, ilgili tarifenin fiyatı (₺ / saat veya ₺ / gün), görünür “Aracı İncele” butonu.
- Puan ve fiyat örnek veriyle gösterilecekse bunlar gerçek bilgi olarak sunulmamalı.
- Uzun özellik listeleri karta sıkıştırılmamalı; Araç Detay ekranında açılmalı.
- Araç görselinde abartılı renk filtresi, yansıma, neon ışık veya yoğun metin bindirmesi kullanılmamalı.
- Seçilen tarih/saat ve konuma göre müsaitlik gerekiyorsa fiyat ve rezervasyon butonu güncel uygunluğa göre güncellenmeli.
Alt navigasyon
Material 3 NavigationBar içinde 5 öğe:
- Ana Sayfa
- Favoriler
- Kiralamalar
- Bildirimler
- Profil
Favoriler ve Kiralamalar profil içinden de erişilebilir; aynı veri/kaynak ve aynı ekranlar kullanılmalı, kopya veri veya ayrık iş mantığı oluşturulmamalı.
7. İkincil Ekranlar
7.1 Karşılama, Giriş, Üye Ol
- İlk ekranda iki net aksiyon: Üye Girişi ve Üye Ol.
- Üye Ol formu: Ad, Soyad, Telefon, E-posta, Şifre, Şifre Tekrar.
- Giriş: Telefon veya e-posta + şifre.
- Material 3 TextFormField, net alan etiketleri, görünür hata mesajları, şifre görünürlük düğmesi.
- Hata ve eksik bilgiler tek başına renk ile ifade edilmemeli.
7.2 Araç Detay
- Büyük araç galeri görseli, özet bilgiler, fiyat, puan/yorumlar, teknik özellikler ve ehliyet sınıfı.
- Alt bölümde net, mümkünse ekranda erişilebilir “Rezerve Et” aksiyonu.
- Özellikleri bölümlere ayır; uzun düz metin duvarları oluşturma.
7.3 Rezervasyon Akışı
- Material 3 uyumlu adım göstergesi: Kiralama tipi → Takvim/süre → Uygunluk/ehliyet → Sözleşme → Fiyat/kupon → Onay/ödeme.
- Dolu tarih veya zaman aralıkları disabled olsun; yalnızca renkleri değiştirilmesin.
- Fiyat ayrıntıları: Birim fiyat, süre, ek ücret/depozito, kupon indirimi, toplam.
- Koşullar/sözleşme onayı bilinçli kullanıcı eylemiyle alınmalı.
- Başarılı işlem ekranı sade, anlaşılır ve rezervasyon özeti içermeli.
7.4 Favoriler ve Karşılaştırma
- Favorilere ekleme/çıkarma hareketleri basit ve anlaşılır olmalı.
- Favoriden çıkarıldığında Snackbar + Geri Al gösterilmeli.
- Karşılaştırma, kullanıcının özellikle seçtiği araçlar arasında gerçekleşmeli; teknik bilgiler ve fiyatlar düzenli tabloda gösterilmeli.
- Küçük ekranlarda yatay taşma kontrollü şekilde yönetilmeli.
7.5 Rezervasyonlarım ve Aktif Araç
- Gelecek / Aktif / Geçmiş / İptal edilen kiralamalar açıkça ayrılmalı.
- Aktif araç için canlı destek ve süre uzatma aksiyonları erişilebilir olmalı.
- Tamamlanan kiralamalarda puanlama, yorum ve fotoğraflı teslim kayıtlarına erişim olmalı.
7.6 Profil, Kuponlar, Destek
- Profilde ayrıntılı ama yalın liste düzeni: Bilgilerim, Rezervasyonlarım, Favorilerim, Kuponlarım, Destek Taleplerim, Yardım & Destek, Kiralama İstatistikleri, Çıkış.
- Kuponlar: Kullanılabilir / Kullanılmış / Süresi dolmuş; geçersiz kuponun “Kullan” aksiyonu disabled.
- Her 3 tamamlanan kiralama sonrasında %20 kupon kazanma için sade ilerleme göstergesi; ilk kullanım kampanyası ayrı tanımlı.
- Destek talepleri: Beklemede / İnceleniyor / Yanıtlandı / Çözüldü.
8. Bileşenler ve Flutter Ders Gereksinimleri
Flutter / Material 3 bileşeni	otoVia kullanımı
AppBar + IconButton	Tema değiştirme, bildirimler
NavigationBar	5 ana sayfa
SearchBar	Marka / model araması
SegmentedButton	Saatlik / günlük kiralama
FilterChip / InputChip	Kategori, seçili filtreler
Card / özelleştirilmiş Material 3 kartı	Geniş tek sütunlu araç kartları
FilledButton	Aracı İncele, Rezerve Et, Onayla
OutlinedButton / TextButton	İkincil işlemler, Vazgeç
TextFormField + Form	Giriş, üyelik, ehliyet bilgileri
showDatePicker / takvim	Tarih seçimi; müsaitliği görsel olarak yansıt
AlertDialog	Rezervasyon, iptal, çıkış onayı
SnackBar + SnackBarAction	Başarı/hata bildirimi, Favoriler için Geri Al
LinearProgressIndicator / stepper	Rezervasyon adımları, kupon ilerlemesi
BottomSheet	Ayrıntılı filtreler, sıralama


Buton davranışları: Boş veya işlevsiz buton bırakma. Yükleme, pasif (disabled), hata ve başarı durumları tanımlı olmalı. Rezervasyonun güvenliğini ilgilendiren bir işlem sadece görsel Snackbar ile “geri alınmış” sayılmamalı; iptal koşulları ve onay süreçleri uygulanmalı.
9. Etkileşim ve Animasyon
- Kısa, ölçülü Material 3 geçişleri tercih et (yaklaşık 150–250ms).
- Tema geçişinde ani göz alıcı flaş/yoğun hareketlerden kaçınılır.
- Favori ekleme gibi küçük etkileşimlerde hafif durum değişikliği; uzun dekoratif animasyonlar yok.
- İşlem sürerken buton durumunu belirt; çift dokunma ile yinelenen rezervasyon/ödeme tetiklenmesini engelle.
- Sayfa içerikleri ve butonlar ekrandaki seçimlere reaktif yanıt vermeli.
10. Erişilebilirlik ve Duyarlı Tasarım
- Dokunmatik hedefler tercihen en az 48 × 48dp.
- Font büyütme, ekran okuyucu etiketleri, mantıklı odak sırası ve kontrast testleri desteklenmeli.
- “Müsait değil”, “Kupon kullanıldı”, “Hata” gibi durumlar yalnızca renkle anlatılmamalı.
- Küçük telefon ekranlarında yatay taşma olmayacak; büyük ekranlarda içerik genişliği sınırlanabilir.
- Fotoğrafların alternatif/semantik açıklamaları ve mantıklı hata/boş liste durumları olmalı.
11. Görsel İçerik Kuralları
- Fotoğraflar temiz, yüksek çözünürlüklü, tutarlı kadraj ve doğal ışıkta tercih edilmeli.
- Araç görselleri kategori ayrımını yansıtsın: motosiklet, binek, SUV, grup ve nakliye.
- Geliştirme aşamasındaki temsili fiyat, model, puan ve fotoğraflar test verisi olarak ele alınmalı.
- Küçük logo/ikonlarda ince, düzenli çizgi üslubu; gereksiz süsleme kullanılmaz.
12. Antigravity Agent için Uygulama Talimatı
1. Kod üretirken önce bu stil.md dosyasını tasarımın tek referansı olarak oku.
2. Mevcut otoVia özellik kapsamını koru; tasarım kararı nedeniyle işlevleri kaldırma.
3. Flutter'da Material 3 destekli merkezi ThemeData.light / ThemeData.dark üret; renk ve tipografi token'larını merkezileştir.
4. AppBar'a tek dokunuşlu tema değiştirici ekle; tema seçimini kalıcı sakla.
5. Ana sayfayı Editorial Layout A olarak, tek sütunlu büyük görselli araç kartları ile oluştur.
6. Light ve Dark temalarda aynı bileşen hiyerarşisini koru; yalnızca uygun renk rolleri değişsin.
7. Türkçe metin kullan; ₺, ₺ / saat, ₺ / gün gösterimlerini bağlama uygun biçimde kullan.
8. Giriş, üyelik, rezervasyon, onay, filtreleme ve favorileme akışlarında Material 3 form, validasyon, dialog ve Snackbar bileşenlerini gerçekten uygula.
9. Görsel tema kararı verilmiş olsa da nihai ekran tasarımları kullanıcı onayı olmadan kesinleşmiş sayılmasın.
10. Gerçek ödeme/ehliyet/doğrulama entegrasyonları yoksa bunu açıkça simülasyon olarak işaretle; sahte “gerçek doğrulama” izlenimi verme.