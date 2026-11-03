// -bu dosyada Flutter'da temel uygulama iskeleti, StatelessWidget ile StatefulWidget farkı ve setState() ile sayaç (counter) yönetimi detaylıca anlatılıyor.-
// Widget: Flutter'da ekranda gördüğümüz (Text, Button, Icon) veya düzen sağlayan (Center, Column, Padding) her şey birer Widget'tır.
// StatelessWidget: Kendi içinde değişen bir durumu (state) olmayan, sabit yapıdaki widget'tır.
// StatefulWidget: Kullanıcı etkileşimi veya veri akışıyla zaman içinde ekranda güncellenebilen (dinamik) widget'tır.
// BuildContext: Bir widget'ın widget ağacındaki (Widget Tree) konumunu ve üst widget'lara (Theme, MediaQuery, Navigator) erişimini sağlayan kimlik/adres nesnesidir.

import 'package:flutter/material.dart';
// import = Başka bir kütüphaneyi dosyamıza dahil eder.
// material.dart = Flutter'ın Material Design widget'larını içerir.
// Örneğin: MaterialApp, Scaffold, AppBar, Text, Column, Center.
// Bu import olmazsa bu widget'ları doğrudan kullanamayız.


void main() {
  // main() = Dart programının başlangıç noktası.
  // void = Fonksiyon geriye herhangi bir değer döndürmez.

  runApp(const MyApp());
  // runApp() = Flutter uygulamasını başlatır.
  // Parametre olarak uygulamanın kök widget'ını alır.
  //
  // MyApp() = MyApp sınıfından bir widget nesnesi oluşturur.
  //
  // const = MyApp nesnesinin sabit oluşturulmasını sağlar.
  // Bunun için constructor'ın const olması gerekir.
  //
  // ÖNEMLİ:
  // runApp() normalde uygulama başlatılırken çağrılır.
  // setState() sırasında tekrar tekrar runApp() çağrılmaz.
}


// ============================================================
// 1. MYAPP SINIFI - STATELESSWIDGET
// ============================================================

class MyApp extends StatelessWidget {
  // class = Yeni bir sınıf tanımlar.
  //
  // MyApp = Oluşturduğumuz sınıfın adı.
  //
  // extends = Kalıtım (Inheritance).
  // MyApp sınıfı StatelessWidget sınıfından miras alır.
  //
  // StatelessWidget = Kendi değiştirilebilir State nesnesi yoktur.
  //
  // IMMUTABLE (DEĞİŞMEZ):
  // Widget'ın özellikleri oluşturulduktan sonra değiştirilemez.
  //
  // ÖNEMLİ:
  // StatelessWidget asla yeniden oluşturulmaz demek değildir.
  // Üst widget değişirse veya bağımlılıkları güncellenirse
  // build() yeniden çalışabilir.
  //
  // Bu sınıfta StatefulWidget kullanmıyoruz.
  // Çünkü MyApp kendi içerisinde sayaç gibi değişen
  // bir durumu yönetmiyor.


  const MyApp({super.key});
  // CONSTRUCTOR (YAPICI METOT)
  //
  // MyApp = Constructor adı sınıf adıyla aynı olmak zorundadır.
  // const = Derleme zamanında sabit nesne üretilmesini sağlar (bellek dostudur).
  // {super.key} = İsimlendirilmiş (named) parametre. Widget'ın ağaçtaki kimliğini (Key) üst sınıf olan StatelessWidget'a aktarır.
  // Key sayesinde Flutter, widget'ların yer değiştirdiğini veya güncellendiğini performanslı şekilde ayırt eder.

  @override
  // @override = Üst sınıfta (StatelessWidget) tanımlı olan soyut build() metodunu kendi sınıfımıza göre yeniden yazdığımızı (ezdiğimizi) belirtir.
  Widget build(BuildContext context) {
    // Widget = Bu metodun geriye bir Widget döndüreceğini belirtir.
    // build() = Arayüzün nasıl görüneceğini tarif eden metottur.
    // BuildContext context = Bu widget'ın ağaçtaki konum bilgisini tutar.

    return MaterialApp(
      // MaterialApp = Uygulamanın genel tema, navigasyon (sayfa geçişleri) ve başlık ayarlarını barındıran ana sarmalayıcı widget.
      debugShowCheckedModeBanner: false, // Sağ üst köşedeki kırmızı "DEBUG" bandını kaldırır (true olsaydı görünürdü).
      title: 'Flutter Demo', // Cihazın görev yöneticisinde (son uygulamalar ekranında) görünen uygulama adı.
      theme: ThemeData(
        // ThemeData = Uygulama genelindeki renk, yazı tipi ve görsel kuralları belirler.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), // Tek bir tohum renkten (deepPurple) uyumlu bir renk paleti üretir.
        useMaterial3: true, // Google'ın en güncel Material 3 tasarım dilini aktif eder.
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      // home = Uygulama açıldığında ekrana ilk gelecek olan ana sayfa widget'ı.
      // title parametresi ile MyHomePage içerisine başlık metnini gönderiyoruz.
    );
  }
}


// ============================================================
// 2. MYHOMEPAGE SINIFI - STATEFULWIDGET
// ============================================================

class MyHomePage extends StatefulWidget {
  // StatefulWidget = Ekranda zamanla değişecek veriler (örneğin butona basıldıkça artan sayaç) olduğunda kullanılır.
  // Kendi başına durumu tutmaz; durumu yönetmesi için bir State sınıfı (_MyHomePageState) oluşturur.

  const MyHomePage({super.key, required this.title});
  // required this.title = MyHomePage oluşturulurken 'title' parametresinin gönderilmesi ZORUNLUDUR.

  final String title;
  // final = Widget sınıfı içindeki değişkenler her zaman final (değişmez) olmalıdır.
  // Değişecek olan veriler bu sınıfta değil, aşağıdaki State sınıfında tutulur!

  @override
  State<MyHomePage> createState() => _MyHomePageState();
  // createState() = StatefulWidget ağaca eklendiğinde onun dinamik durumunu yönetecek olan _MyHomePageState nesnesini oluşturur.
  // => (Fat Arrow) = Tek satırlık return ifadesinin kısa yazımıdır.
}


// ============================================================
// 3. _MYHOMEPAGESTATE SINIFI - STATE (DURUM YÖNETİMİ)
// ============================================================

class _MyHomePageState extends State<MyHomePage> {
  // Baştaki alt çizgi (_) = Bu sınıfın private (özel) olduğunu, sadece bu dosya içinden erişilebileceğini belirtir.
  // State<MyHomePage> = Bu durum sınıfının MyHomePage widget'ına ait olduğunu belirtir. Bu sayede içeride 'widget.title' diyerek üst sınıftaki veriye ulaşabiliriz.

  int _counter = 0;
  // _counter = Ekranda değişecek olan durum (state) değişkenimiz. final DEĞİLDİR çünkü her butona basıldığında değeri artacaktır.

  void _incrementCounter() {
    // _incrementCounter() = Artırma butonuna basıldığında çalışacak fonksiyon.
    setState(() {
      // setState() = İçerideki değişkenin güncellendiğini Flutter'a bildirir ve build() metodunun YENİDEN ÇALIŞMASINI tetikler!
      // ÖNEMLİ: Eğer _counter++ işlemini setState() dışında yapsaydık, bellekte sayı artardı AMA ekran yeniden çizilmediği için kullanıcı hep 0 görürdü!
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Her setState() çağrıldığında bu build() metodu tekrar çalışır ve güncel _counter değeriyle ekranı yeniden çizer.
    return Scaffold(
      // Scaffold = Sayfanın temel görsel iskeletini (AppBar, Body, FloatingActionButton, Drawer vb.) kurar.
      appBar: AppBar(
        // AppBar = Ekranın en üstündeki başlık çubuğu.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary, // Tema renginden uyumlu bir arka plan rengi alır.
        title: Text(widget.title), // widget.title = Üst sınıf olan MyHomePage içindeki 'title' değişkenine erişir.
      ),
      body: Center(
        // Center = İçindeki çocuğu (child) ekranın tam ortasına hizalar.
        child: Column(
          // Column = Çocuklarını (children) yukarıdan aşağıya DİKEY olarak dizer.
          mainAxisAlignment: MainAxisAlignment.center, // Dikey eksende (Column'un ana ekseni) elemanları ortalar.
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:', // Sabit açıklama metni; değişmediği için const olarak işaretlenmiştir (performans için yeniden oluşturulmaz).
            ),
            Text(
              '$_counter', // String Interpolation ($): _counter tam sayısını metne dönüştürerek ekrana yazar. Değişken olduğu için const OLAMAZ!
              style: Theme.of(context).textTheme.headlineMedium, // Temadan büyük başlık yazı stilini uygular.
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // FloatingActionButton = Ekranın sağ alt köşesinde havada duran yuvarlak aksiyon butonu.
        onPressed: _incrementCounter, // Butona tıklandığında _incrementCounter fonksiyonunu tetikler (parantez () yazılmaz, fonksiyonun referansı verilir).
        tooltip: 'Increment', // Butona uzun basıldığında çıkan ipucu metni.
        child: const Icon(Icons.add), // Butonun içindeki '+' ikonu.
      ),
    );
  }
}

// ÇALIŞMA MANTIĞI:
// main() çalışır -> runApp(const MyApp()) kök widget'ı başlatır -> MaterialApp oluşturulur ve home olarak MyHomePage açılır
// -> createState() ile _MyHomePageState bellekte oluşturulur -> İlk build() çalışır ve ekranda 0 görünür
// -> Kullanıcı '+' butonuna basar -> _incrementCounter() çağrılır -> setState() içinde _counter 1 artar
// -> Flutter _MyHomePageState'in build() metodunu yeniden çalıştırır -> Ekranda yeni değer (1) gösterilir.

// STATELESSWIDGET : Durumu değişmeyen, kendi içinde setState() barındırmayan sabit arayüz bileşenleridir (Örn: MyApp, sabit bilgi kartları).
//  VS
// STATEFULWIDGET : Kullanıcı etkileşimi veya veri değişimiyle zaman içinde güncellenen, State nesnesi ve setState() ile ekranı yeniden çizebilen dinamik bileşenlerdir (Örn: MyHomePage, formlar, sayaçlar).
