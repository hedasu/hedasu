## Sözleşmeler, SOLID prensipleri & OOP mimarisi

### 1.1 Interface (arayüz/sözleşme)

**Sözlük Anlamı:** İki bağımsız sitemin veya sınıfın birbiri ile nasıl konuşacağını belirleyen, içi boş metot imzalarından oluşan kurallar bütünü.

**Neden Kullanılır? :** Bir sınıfa göbekten bağımlı kalmamak (örn. gerçek şarj istasyonu cihazı olmadan sahte/mock şarj servisiyle testi çalıştırabilmek) için.

```dart
abstract interface class StationContreact {
    Future<void> startCharging(String socketId);
    Stream<double> watchLivePower();
}
```
---

### 1.2 `implements` vs  `extends` vs `with`

### 1.2.1 `implements` (Arayüz Sözleşmesi)
**sözlük anlamı:** bir sınıfın, bir şablonun belirlediği kuralları kabul edip **içini sıfırdan kendisinin doldurması** zorunluluğudur. 
**Neden kullanılır :** farklı sınıflara ortak bir standart/swözleşme dayatmak, çoklu arayüz desteği sağlamak ve kodda bağımlılıkları azaltmak için.

### 1.2.2 `extends` (kalıtım/miras)
**Sözlük Anlamı :** bir sınıfın, başka bir sınıfın özelliklerini ve metotlarını doğrudan devralmasıdır.
**Neden kullanılır:** kod tekrarını önlemek (DRY), mantıksal bir sınıf hiyerarşisi oluşturmak için.

### 1.2.3 `with` (mixin/yetenek aşılama)
**Nedir :** sınıf hiyerarşisini bozmadan, bağımsız bir sınıfa hazır kod blokları (metotlar ve değişkenler) enjekte etme mekanizmasıdır.
**Neden kullanılır :** akraba olmayan sınıflara ortak yetenek kazandırmak,çokjlu kalıtım kimliğini önlemek ve modülerliği artırmak.




| Özellik | implements | extends | with |
|---|---|---|---|
| Temel Felsefe| ben senin çocuğunum,genlerini alıyorum | seninle sözleşme imzaladım,maddeleri ben yapacağım. | ben ana sınıfıma ek bir uzmanlık yeteneği takıyorum |
| gövdesi dolu metot gelir mi? |evet, üst sınıfın metotlarını doğrudan kullanır.| hayır! üst sınıfın içi dolu olsa bile hepsi silinir,sıfırdan yazılır. | evet, mixin içindeki hazır metotlar sınıfa eklenir |
| kaç tane kullanılabilir? | sadece 1 (dartta çoklu kalıtım yasak) | sınırsız("," ile onlarca interfce uygulanabilir) | sınırsız("," ile onlarca mixin eklenebilir) |
| constructor var mıdır? | evet | hayır(interfacein constructor ı olmaz) | hayır |

---

### 1.3 SOLID prensipleri (Mobil & Dart Odaklı)

#### 1. S - Single Responsibility Principle (Tek Sorumluluk Prensibi)
***kural:*** bir sınıfın veya dosyanın değişmesi için **yalnızca 1 sebebi** olmalıdır.

#### 2. O - Open/Closed Principle (Açık/Kapalı Prensibi)
***kural:*** yazılım varlıkları(sınıflar,modüller) **genişletilmeye AÇIK,ancak değiştirilmeye KAPALI** olmalıdır.

#### 3. L - Liskov Substitution Principle (Liskov Yerine Geçme Prensibi)
***kural:***  bir üst sınıfın yerine onun alt sınıflarından herhangi biri geçirildiğinde sistem davranışı bozulmamalı ve hata fırlatmamalıdır. 

#### 4. I - Interface Segregation Principle (Arayüz Ayrıştırma Prensibi)
***kural:*** istemciler(sınıflar), kullanmadıkları metotları içermeye zorlanmamalıdır. Şişman(fat) interfaceler yerine küçük amaca yönelik arayüzler kurulmalıdır.

#### 5. D - Dependency Inversion Principle (Bağımlılık Tersine Çevirme Prensibi)
***kural:*** yüksek seviyeli modüller (UI iş mantığı), düşük seviyeli modüllere (veritabanı,HTTP istemcisi) doğrudan bağlı olmamalıdır. Her ikiside soyutlamalara (Abstract Interface) bağlı olmalıdır.

---

### 1.4 `coupling` (bağlaşıklık) & `cohesion` (uyumluluk)
***Tightly Coupled(sıkı bağımlı):** sınıfların birbirinin her detayını bilmesi. birinde yapılan bir harflik değişiklik diğerr 5 dosyayı bozuyorsa sistem sıkı bağımlıdır.

***Loosly Compled(gevşek bağımlı):** sınıfların sadece interface üzerinden konuşması. biri değişirse diğerleri etkilenmez.

***high cohesion(yüksek uyum):** bir sınıfın sadece ve sadece kendi uzmanlık alanını yapması. 

---


## STREAM TEMELLERİ, CUBIT & ENTERPRISE BLOC
### 2.1 `Stream` Nedir? (BloC'un Kalbindeki Motor)

**sözlük anlamı:** zaman içinde parça parça gelen,akıp giden asenkron veri dizisi.

**BLOC sırrı:** BLOC kütüphanesi sihirli bir şey yapmaz! BLoC'un içinde gizli `StremController` vardır. Event'ler borunun bir ucundan girer (`sink.add`), BLoC onları işler ve diğer ucundan ekrana state akıtır.(`stream.listen`).


| Kriter | Cubit(hafif BLoc) | BLoC(event-driven) | 
|---|---|---|
| Tetikleme mekanizması | Doğrudan metot çağrısı: cubit.loadStations() | event:fırlatma: bloc.add(LoadStationsEvent()) | 
| kod miktarı | az dosya,sade ve hızlı | event dosyası + state dosyası + BLoC dosyası|
| izlenebilirlik(traceability) | sadece hangi fonksiyonun çağrıldığı bilinir. | hangi event'in hangi state'e yol açtığı saniye saniye izlenir |
| event dönüştürücü (debounce/throttle) | Elle timer veya flag kurmak gerekir | transformer: restartable() ile tek satırda çözülür |
| ne zaman tercih edilmeli? | basit formlar, tema değiştirme, tab geçişleri, profil | şarj başlatma/bitirme, sepet akışı, bakiye transferi, kimlik doğrulama | 

---

### 2.3 BLoC'un 3 Temel Elemanı : `Event` , `State`, `Emitter`

**Event (Olay)** Kullanıcının veya sistemin BLoC'a attığı emir fişi
*Mini Sözdizimi:* `class StartChargingRequested extends ChargingEvent{ final String socketId; }`

**State (Durum)** ekranın o milisaniyedeki dondurulmuş fotoğrafı(snapshot).
*Mini Sözdizimi:* `class ChargingActiveState extends ChargingState { final double kwh;}`

**Emitter (Yayıncı)** BLoC'un ürettiği yeni state'i ekrana fırlattığı megafon borusu.
*Kural:* Senkron çalışır; `emit(NewState())` dendiği anda UI'daki builder'lar tetiklenir.


## State Değiştiğinde Ne Yapmak İstiyorsun?


| İhtiyaç | Kullanılacak Widget | Örnekler |
|---|---|---|
| Sadece arayüz çizmek | `BlocBuilder` | Kart basmak, spinner döndürmek, listeyi render etmek |
| Sadece yan etki tetiklemek | `BlocListener` | SnackBar göstermek, showDialog() açmak, context.go() ile gitmek |
| Hem arayüz çizmek hem yan etki tetiklemek | `BlocConsumer` | Hata olunca SnackBar göstermek ama listeyi ekranda tutmak |

---

Kullanıcı ekrandayken asenkron işlem başlar (await api.fetchSockets()). Kullanıcı cevap gelmeden geri tuşuna basıp sayfayı kapatır. BLoC/Cubit yok edildiği (closed) için hemen ardından gelen emit() satırı:

💥 StateError: Cannot emit new states after calling close

hatasını fırlatır ve uygulama çöker!
Çözüm: Asenkron await satırından sonraki her emit mutlaka şu şekilde korunmalıdır:
final data = await repository.getData();
if (!isClosed) {
  emit(DataLoaded(data));
}


---



## STREAM TEMELLERİ, CUBIT & ENTERPRISE BLOC

### 3.1 `Side Effect` (Yan Etki) Neden `BlocBuilder` İçine Yazılamaz?

* `BlocBuilder`'ın tek görevi **Widget döndürmektir**.

* Flutter motoru ekranı saniyede 60 kez çizebilir (Rebuild). Eğer siz `BlocBuilder` içine `ScaffoldMessenger.showSnackBar` veya `Navigator.push` yazarsanız; kullanıcı cihazı yan çevirdiğinde veya klavye açıldığında kullanıcıya **üst üste 10 defa SnackBar patlar veya 10 kez yeni sayfa açılır!**

* **Kural:** Yan etkiler SADECE `BlocListener` içine yazılır; çünkü `listener` sayfa rebuild olduğunda değil, **yalnızca State değiştiğinde 1 kez** tetiklenir!


### 3.2 `BlocSelector` (Mikro Performan & Pil Tasarrufu) 
* **Kavram:** State'in içindeki onlarca alandan sadece **1 tanesini süzüp izlemek**. 



---


## 4. EŞİTLİK, DEĞİŞMEZLİK & BLOCOBSERVER

### 4.1 `Referential Equality` vs `Value Equality`

* **Dart Varsayılanı (referans eşitliği):** İki nesnenin bellekteki (RAM) adresi aynı mı?
    `Soket(`A`)` == Soket(`A`) -> **FALSE** İçerikler aynı olsa da RAM`deki evleri farklıdır.

* **Değer Eşitliği (Value Equality):** Nesnelerin içerikleri aynı mı? 
    `Soket(`A`)` == Soket(`A`) -> **TRUE** 
    `Equatable` paketi tam olarak bunu çözer: Nesneleri RAM adresine göre değil, `props` listesindeki alanların değerine göre karşılaştırır.



### 4.2. `props` Listesi Yazılmazsa Ne Olur?

* BLoC ekran kartını yormamak için şu denetimi yapar: `if (yeniState == eskiState) ekranıCizme();`.

* Eğer siz `StationLoaded` state'ine yeni bir `filterType` alanı eklerseniz ama `props` içine yazmayı unutursanız; BLoC iki state'i eşit zanneder ve **ekranı güncellemez, arayüz donuk kalır!**


### 4.3. 'Immutability' (Değişmezlik) & 'copyWith'
* **Kural:** State siniflarınin tüm alanları
'final' olmalıdır (Değişmez).
* **copyWith' Mantığı:** Eski nesnenin 5 alanını koruyup, sadece değişen 1 alanını güncelleyerek taze bir nesne üretme yöntemidir.
```dart
final guncel = state.copywith(isCharging:
true); // Diğer alanlar bozulmadan kopyalanır
```


### 4.4. `BlocObserver` (Tüm Uygulamayı Röntgenleme)

* **Kavram:** Uygulamadaki tüm BLoC ve Cubit'lerin arkasında çalışan merkezi bir kara kutu / telemetri kaydedici.

* **Ne İşe Yarar?:** Hangi ekranda hangi Event fırlatıldı, State nereden nereye geçti (`onTransition`) ve nerede hata fırlatıldı (`onError`) tek merkezden konsola loglanır. Kurumsal projelerde analitik ve çökme takibi için zorunludur. 



---


### 1. PRESENTATION (Görsel Katman)
- UI ekranları, butonlar, theme, BLoC, Cubit

⬇️ **Bağımlılık içeri bakar**

### 2. DOMAIN (İş Kuralları – En Kutsal Katman)
- Entity (saf veri), UseCase (iş kuralları)
- Repository Interface (sözleşmeler)

**Kural!!!** Dış dünyadan (JSON, Dio, SQLite) asla bilgi içermez! Sıfır harici paket importu!

⬆️ **Sözleşmeyi uygular**

### 3. DATA (Veri Altyapısı)
- Model / DTO (`fromJson` / `toJson`)
- Remote DataSource (Dio ile API)
- Local DataSource (Hive / SharedPreferences ile disk)
- Repository Implementation

---


## 5. CLEAN ARCHITECTURE KATMANLARI & SORUMLULUK DUVARLARI

### 5.1 `Entity` ve `Model / DTO` 

* **`Entity` (Varlık):** Saf iş nesnesidir. Bir şarj soketinin gerçek hayattaki özelliklerini (`id`, `kw`, `durum`) tutar. `fromJson` veya `toJson` İÇERMEZ.

* **`Model / DTO` (Data Transfer Object):** API'den gelen ham JSON verisini karşılayan taşıyıcıdır. `Entity`'den türer; `fromJson` ve `toJson` metotlarını barındırır.

* **Soru:** *"Neden Entity içine `fromJson` yazmıyoruz?"*
  * **Cevap:** Yarın Backend JSON yerine XML veya Protobuf formatına geçerse; Domain katmanındaki iş kurallarımız ve UI sayfalarımız zerre kadar etkilenmesin,sadece DATA katmanındaki Model etkilensin diye



### 5.2. `UseCase` (Kullanım Senaryosu)

* **Kavram:** Kullanıcının veya sistemin gerçekleştirebileceği **tek ve atomik bir iş kuralı**.

* **Örnekler:** `StartChargingSessionUseCase`, `GetStationSocketsUseCase`, `RefundWalletBalanceUseCase`.

* **Kural:** Her UseCase sınıfının içinde sadece tek bir call() veya execute() fonksiyonu bulunur.



### 5.3. `Repository Contract` vs `Repository Implementation`

* **Contract (Domain Katmanında):** Sözleşmedir (`abstract interface class StationRepository`). Verinin nereden geleceğini bilmez.

* **Implementation (Data Katmanında):** Sözleşmeyi uygulayan somut sınıftır (`class StationRepositoryImpl implements StationRepository`). Verinin önce yerel diskten mi yoksa internetten mi çekileceğine karar verir.


---


## 6. BAĞIMLILIK YÖNETİMİ: DEPENDENCY INJECTION & `get_it`

### 6.1. Neden `new Dio()` Yazmak Yasaktır?

Eğer 5 ayrı sayfada `final dio = Dio();` derseniz:

1. Bellekte 5 ayrı bağlantı havuzu açılır, telefonun soket sınırını zorlar.
2. Base URL veya Timeout değiştiğinde 5 ayrı dosyayı elle değiştirmek zorunda kalırsınız.
3. Test yazarken sahte (mock) veri enjekte edemezsiniz.


### 6.2. `GetIt` Kayıt Tipleri: Singleton vs LazySingleton vs Factory

* **`Singleton`:** Uygulama açıldığı milisaniyede nesneyi üretir ve belleğe çiviler.

* **`LazySingleton`:** Uygulama açıldığında üretmez! Ne zaman ilk kez birisi `sl<Dio>()` derse o an üretir ve sonrasında hep aynı nesneyi verir. (Bellek ve açılış hızı dostudur).

* **`Factory`:** Her çağrıldığında **yepyeni, sıfır bir kopya** üretir.



---



## 7. KURUMSAL AĞ MİMARİSİ: DIO, INTERCEPTOR & HTTP STATUS KODLARI

### 7.1 INTERCEPTOR
* **Sözlük Anlamı:** Ağ isteği telefondan çıkıp internete gitmeden önce veya sunucudan cevap gelip koda düşmeden önce araya girip paketi inceleyen/değiştiren güvenlik noktası.


### 7.2. `Bearer Token` & `Payload`

* **Bearer Token:** "Bu anahtarı taşıyan kişi giriş yapmaya yetkilidir" anlamına gelen şifrelenmiş kimlik kartı metni (`Authorization: Bearer eyJhbGci...`).

* **Payload:** Bir API isteğiyle sunucuya gönderilen veya sunucudan bize dönen asıl veri gövdesi (Body).


### 7.3. HTTP Durum Kodları Sözlüğü

* **`200 OK`:** İstek başarılı, veri gövdede.
* **`201 Created`:** Yeni kayıt (örneğin yeni şarj oturumu) başarıyla oluşturuldu.
* **`400 Bad Request`:** İstemci hatası; eksik veya hatalı parametre gönderdin.
* **`401 Unauthorized`:** Token yok veya süresi dolmuş; hemen Login'e yönlendir!
* **`403 Forbidden`:** Giriş yaptın ama bu veriyi görmeye yetkin yok (Admin değilsin).
* **`404 Not Found`:** Aradığın soket veya istasyon sunucuda bulunamadı.
* **`500 Internal Server Error`:** Backend sunucusu patladı; istemcilik bir hata yok.


---



## 8. VERİ DAYANIKLILIĞI: CACHE-FIRST & SAVUNMACI KODLAMA

### 8.1. `Cache-First` (Önce Önbellek) Stratejisi

* **Mantık:** Kullanıcı şarj istasyonu listesini açtığında 1 saniye bile beyaz ekranda spinner bekletme! Diskteki dünkü veriyi **0.01 milisaniyede** ekrana bas. Arka planda sunucudan taze veriyi çek; gelince ekranı ve diski sessizce güncelle.



### 8.2. `Defensive Programming` (Savunmacı Programlama)

* **Mantık:** Sunucudan gelen veriye asla %100 güvenmeme prensibi.

