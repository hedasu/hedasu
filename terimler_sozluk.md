const
1) ne işe yarar? : içine girilen değerleri derleme zamanında tek bir kere yazılarak değişmez olarak üretir.
2) Neden kullanılır? : bir widget const olarak tanımlanırsa setState olduğunda flutter nu widgeti yeniden üretmez CPU ve pil tasarrufu sağlar.

final
1) ne işe yarar? : çalışma zamanında değeri birkez atanan ve referansı asla değiştirilmeyen değişkenler.
--- Const ve final farkı: const derlenirken bilinmek zorunda (const pi=3.14) final ise çalışma anında belirlenebilir (final saat = Datetime.now()) ---Model sınıflarında alanlar her zaman final olmalıdır. ---

late
1) ne işe yarar? : değişen tanımlandığı anda değil, ilk kullanıldığında veya initState anında başlayacağı zaman kullanılır.

required
1) ne işe yarar? : isimlendirilmiş parametrelerde o parametrenin(değişkenin) zorunlu olduğunu beirtir.

@override
1) ne işe yarar : alt sınıfın üst sınıftan devraldığı metodu ezdiğini belirtir.
2) faydası : eğer üst metod adını yanlış yazarsanız (örnek build yerine builds yazarsanız) derleyici @override sayesinde bunu anında hata olarak yakalar


Null-aware operatörleri (? ?? !)
?. - place?.title -> eğer place null ise hata vermez direkt null olarak döner
?? - if null : final id =state.userId ?? 10; -> sol taraf null ise sağdaki (hardcode-olan değer) otomatik olarak atanır.
! (null / force) : final id = state.userId ! -> bu kod derleyiciye "bana güven bu değer o anda kesinlikle null değil" der. eğer null gelir ise uygulama anında çöker. (ÇOK DİKKATLİ KULLANILMALI).


Spread operatörü(...)
1) ne işe yarar : bir listenin elemanlarını tek tek çıkartıp bulunduğu üst listenin içine ekler. Column ve listView içinde dinamik kart dizini kullanmak için en temiz yöntemdir.
...listeAdi.map((p)=> _buildCard(p)) 


initState()
1) Ne zaman çalışır? : widget ağaca fiziksel olarak ilk başladığında yalnızca 1 kere çalışır.
2) Ne Yapar? : ScrollController başlatmaları ve ilk api istekleri burda kurulur. 
Kural : içinde doğrudan BuilContext ile Navigator çağırılmaz çünkü widget ağaca tam oturmamıştır.


didChangeDependencies()
Ne zaman çalışır: initState()'ten hemen sonra ve widget dinlendiği bir (örnek : Theme.of(context)) değiştiğinde otomatik sağlanır.
ne yapar: BuildContext güvenli bir şekilde erişerek tema veya ekran boyutu bağımlılıkları ile ilgili yüklemeler burada yapılır.


build(BuildContext context)
Ne zaman çalışır : Sayfa ilk açıldığında , setState() çağrıldığında veya üst widget yeni bir inşa ağaç boyama geldiğinde saniyesinde defalarca çalışır.
Kural(): build() metodu tamamen saf olmalıdır. Asla içinde setState() api isteği ya da controller başlatma yapılmamalıdır. Sadece UI döndürülmelidir. 


dispose()
Ne zaman çalışır: Widget hafızadan atılmadan hemen önce son kez çalışır.
Ne yapılır _controller.dispose() stream dinleyicilerin iptallaeri burada yapılır. super.dispose() un mutlaka son satırda çalıştırılması gerekir.


setState((){})
1) arka planda ne yapar? : State'in bağlı olduğu StatefulElement nesnesine "ben değiştim, build et" sinyali gönderir.
2) nerede kullanılır? : Sayfa genelini çizdirmez. Sadece onu dinleyen küçük ValueListenableBuilder 'a sinyal gönderilir.


ValueNotifier<T>
1) arka planda ne iş yapar ? : ChangeNotifier sınıfından türer. Belleğinde tek bir nesne referansı tutar. (T _value)
2) tetikleme değer atandığında (set value(T value)), eğer yeni değer eski değere eşit değilse (_value!=newValue), kayıtlı olan fonksiyonu çağrılır.(addListener(() {}))


InheritedWidget
1) ne yapar : Widget ağacında alttaki childların, aradaki onlarca widgetı baypas ederek, üst widgetın verisine (state'ine) doğrudan erişimini sağlayan soyut bir widgettır.

Material 3 Tasarım Dili Renk Algoritması ve temalar

primary: Ana marka rengi
onPrimary: Ana rengin üstüne yazılacak yazı rengi(okunabilirlik açısından)
primaryContainer: Ana rengin yumuşak pastel arkaplan tonu
onprimaryContainer: Ana rengiin yumuşak patel arkaplan tonunun üstüne yazılacak yazı (okunabilirlik açısından)
surface: sayfa arkaplan yuvali
onSurface: Sayfa üstündeki ana metin rengi
outLineVariant: İnce sınır ve ayrım çizgilerinin rengi

ThemeMode.system
color:Colors.black.withOpacity(0.8) --> HATA verir tam sayı değer girmen gerekir 1 ile 255 arası

color:Colors.blackwithValues(alpha: 186/255) // double sayı olarak girilmelidir. **Güncel ve doğru yöntem**

Arayüz Düzen ve Liste Bileşenleri

Expanded ve Flexible
Expanded: Kalan boş alanın TAMAMINI kaplamaya başlar
Flexible: Kalan boş alanı flex (esneklik) oranına göre paylaştırır. ---Yetersiz alan varsa flex widgetlar küçülmeye çalışır, Expanded ise hata verir.---- 
Flex: yanyana iki widget varsa biri flex1 diğeri flex2 bu sayede ekran boyutuna gör eotomatik olarak ayarlanır.(flexible'ın childı)

Stack ve Positioned
Ne yapar: Widget'ları z ekseninde üst üste bindiri.
Positioned: Yalnızca bir Stack içinde çalışır.
top:10, right:10 vererek bir resmin sağ üst köşesine bildirim rozeti eklemenizi sağlar.

ListView.builder
Klasik ListView(children:[...],) içindeki örnek vermek gerekirse 10.000 elemanın tamamını daha sayfa açılmadan belleğe yükler ve doğal olarak telefon donar.
ListView.builder ise Geri Dönüşümlü Görünüm alanı mantığını kullanarak ekranda sadece o an eğer 5 kart görünecek ise sadece 5 kartı ram belleğe yükler. Kullanıcı aşağıya kaydıkça yukarıda kalanlar bellekten düşürülüp altta kalan belleğe taze olarak yeni üretilir.

shrinkWrap: true
Bİr ListView baş bir dikey kaydırıcının (singleChildScrollView) içine konursa Vertical viewport hatası verir
shrinkWrap true verilerek bu çözülebilir ancak ListView in sonsuza kayma (sonsuz scroll) özelliği kaybolur. 
**Sadece 3 5 elemanınız varsa bunu kullanmalısınız.**

Inkwell ve GestureDetector
GestureDetector : Tıklama çift tıklama sürükleme olaylarını yakalar ama GÖRSEL HİÇBİR TEPKİ VERMEZ.
Inkwell: tıklandığı an parmağın altından dışa doğru yayılan bir su dalgası efekti (ink splash) verir.

Önemli Kural : Inkwell'in arkasında mutlaka bir material widget olmak zorundadır. Aksi takdirde su dalgası arkadaki tuvali göremediği için hiçbir şekilde görünmez.


Form Mimarisi

GlobalKey<FormState> 

Widget içindeki form düğümüne doğrudan dışardan erişilemiyor.Bu yüzden widgetın en üstüne koyduğumuz globalKey değişkeni sayesinde formun Validate (geçerli) durumunu ve içindeki değerleri (değişkenlri) dışarıdan okuyabiliyoruz.

_formKey.currentState?.validate() çağrıldığında o formun altındaki tüm TextFormField validator bloklarını sırayla çalıştırır.

validator : (String? value)

fonksiyonda bir hata bulursa geriye String olarak hata metni dönderir. Bu metin otomatik olarak kırmızı renkte ve inputun altında belirir. Eğer Veri geçerliyse null döner. Flutter için bu alanda hata yok demektir (Null Gelmesi)


Animasyon Motoru

AnimatedContainer : Genişlik, yükseklik padding margin border renk ve gölge oynatır.
AnimatedOpacity : Görünürlüğü 0.0 ile 1.0 arasında yumuşakça soldurur.
AnimatedScale : Widget merkezinden dışarıya doğru büyütüp küçültür.
AnimatedAlign : Widget kutunun. içinde sağdan sola yukarıdan aşağıya karşı konumunu değiştirir.


Curves
İvmelenme Karakterleri

Curves.linear : Sabit hız (robotik hareketler)
Curves.easeInOut : Yavaş başlar ortada hızlanır ve yavaşça durur.
Curves.bounceOut : Hdefe çaptığında top gibi 2 3 kez yaylanarak seker.
Curves.elasticOut : LAstik gibi ileri geri titreyerek yerine oturur.


Gorouter

alt taraftaki menü : shell router
geri kalan sayda : gorouter

context.go('/profile') : Route Yönlendirmesidirr. Rota tablosunda hiyerarşiyi takip eder sayfayı temizleyebilir.

context.push('/profile/5') Stack yönledirmedir. Kullanıcı nereden gelirse gelsin mevcut sayfanın tepesine yeni bir katman ekler ve dönüş sayfası için bir geri ok butonu ekler.

context.pop() sayfanın en üstteki yığınını kapatır


state.pathPArameters ["id"] Gorouter içinde tanımladığımız /:id yapılarına erişmek için kullanılır.

/profil?user=berat
state.url.queryParameters["user"] : 'berat'  opsiyonel filtreleme ya da arama zamanlarında kullanılır. 


Cihaz içi yerel depolama mimarileri

SharedPreferences : 
Küçük kullanıcı ayarları
Düşük güvenilirlik
Okuma yazma hızı: Okuma orta, yazma daha yavaş


FlutterSecureStorage : 
Şifre Token vb. Saklama
En yüksek güvence
Okuma yazma hızı: orta (her veriyi kripto olarak şifreler)

Hive/Isar:
Yüksek Performanslı nesne depolama
Orta güvenlik(isteğe bağlı şifreleme açılabilir)
Okuma yazma hızı: Aşırı hızlı






 