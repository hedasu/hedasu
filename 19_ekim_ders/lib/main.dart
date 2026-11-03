// -bu dosyada uygulamanın başlangıç noktası (entry point), kök widget yapısı, alt navigasyon kabuğu (shell) ve controller'ların yaşam döngüsü (lifecycle) anlatılıyor.-
// StatelessWidget : İçinde değişen bir durum (state) barındırmayan, sadece dışarıdan aldığı verilerle çizilen durağan widget türü.
// StatefulWidget : Kullanıcı etkileşimi veya veri değişimiyle arayüzün güncellenmesi gereken durumlarda kullanılan dinamik widget türü.
// initState() : StatefulWidget ekrana ilk kez çizilmeden hemen önce SADECE BİR KEZ çalışan başlangıç (initialization) metodudur.
// dispose() : Widget ağaçtan kalıcı olarak kaldırıldığında (ekrandan silindiğinde) çalışan ve kullanılan kaynakları/dinleyicileri temizleyen metottur. BELLEK SIZINTISINI (MEMORY LEAK) ÖNLEMEK İÇİN KRİTİKTİR.
// late final : Değişkenin değerinin tanımlandığı anda değil, birazdan (örneğin initState içinde) atanacağını (`late`) ve atandıktan sonra bir daha asla değiştirilemeyeceğini (`final`) belirtir.

import 'package:flutter/material.dart'; // material.dart : Flutter'ın Material Design görsel bileşenlerini (Scaffold, AppBar, NavigationBar vb.) projeye dahil eder.
import 'core/constants/app_colors.dart'; // app_colors.dart : Uygulama genelinde kullanılan sabit neon ve koyu arka plan renklerini içe aktarır.
import 'core/theme/app_theme.dart'; // app_theme.dart : Material 3 tabanlı koyu tema (darkTheme) yapılandırmasını içe aktarır.
import 'features/badges/controller/badge_controller.dart'; // badge_controller.dart : Rozet kazanım mantığını yöneten denetleyici sınıfı.
import 'features/badges/view/badge_view.dart'; // badge_view.dart : Rozetlerin listelendiği ekran görünümü.
import 'features/water_tracker/controller/water_tracker_controller.dart'; // water_tracker_controller.dart : Su tüketim durumunu yöneten denetleyici sınıfı.
import 'features/water_tracker/view/water_tracker_view.dart'; // water_tracker_view.dart : Su takip ekranı görünümü.
import 'features/workout/controller/workout_controller.dart'; // workout_controller.dart : Egzersiz ve kalori durumunu yöneten denetleyici sınıfı.
import 'features/workout/view/workout_view.dart'; // workout_view.dart : Egzersiz takip ekranı görünümü.

void main() { // main() : Dart ve Flutter uygulamalarının çalışmaya başladığı ana giriş fonksiyonudur | void : geriye değer döndürmez.
  runApp(const SusadimApp()); // runApp() : Verilen widget'ı ekranın kök (root) bileşeni olarak bağlar ve çizim motorunu başlatır | const : derleme zamanı sabiti (performans için yeniden oluşturulmaz).
}

/// Susadım Uygulama Kök Widget'ı.
class SusadimApp extends StatelessWidget { // class SusadimApp : Uygulamanın en dış kapsayıcı sınıfı | extends StatelessWidget : durumsuz widget özelliklerini miras alır.
  const SusadimApp({super.key}); // const kurucu : Widget'ın değişmez olduğunu belirtir | super.key : Widget ağacında kimlik takibi için üst sınıfa (StatelessWidget) anahtar iletir.

  @override // @override : Üst sınıftan (StatelessWidget) gelen soyut build metodunu ezerek kendi tasarımımızı yazdığımızı belirtir.
  Widget build(BuildContext context) { // build() : UI'ı çizen metot | BuildContext context : Widget'ın ağaçtaki konumunu ve üst verilerini (tema, ekran boyutu vb.) taşır.
    return MaterialApp( // MaterialApp : Uygulamanın yönlendirme (routing), tema ve başlık gibi temel Material altyapısını kuran kök widget.
      title: 'Susadım', // title : Cihazın görev yöneticisinde (son kullanılan uygulamalar ekranında) görünen uygulama adı.
      debugShowCheckedModeBanner: false, // debugShowCheckedModeBanner: false : Sağ üst köşedeki kırmızı "DEBUG" şeridini kaldırır (true olsaydı geliştirme aşamasında görünürdü).
      theme: AppTheme.darkTheme, // theme : Uygulamanın genel görsel stilini AppTheme içindeki darkTheme ile yapılandırır.
      home: const MainNavigationShell(), // home : Uygulama açıldığında ilk gösterilecek ana ekran widget'ı.
    );
  }
}

/// Sadece yerel arayüz sekme geçişini yöneten kabuk (Shell) widget.
class MainNavigationShell extends StatefulWidget { // StatefulWidget : Hangi sekmenin seçili olduğu (_currentTabIndex) değiştiğinde ekranın güncellenmesi gerektiği için kullanılır.
  const MainNavigationShell({super.key}); // super.key : Widget kimliğini üst sınıfa aktarır.

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState(); // createState() : Bu StatefulWidget'ın durumunu (state) yönetecek olan _MainNavigationShellState nesnesini oluşturur ve bağlar.
}

class _MainNavigationShellState extends State<MainNavigationShell> { // _MainNavigationShellState : Başındaki '_' (alt çizgi) bu sınıfın private (sadece bu dosyada erişilebilir) olduğunu gösterir.
  int _currentTabIndex = 0; // _currentTabIndex : Alt menüde aktif olan sekmenin sırasını tutar (0: Su Takibi, 1: Egzersiz, 2: Rozetler).
  late final WaterTrackerController _waterController; // late final : Su takip denetleyicisi; initState içinde bir kez oluşturulacak ve referansı hiç değişmeyecek.
  late final WorkoutController _workoutController; // late final : Egzersiz takip denetleyicisi; sekmeler arası geçişte verilerin kaybolmaması için burada (üst kabukta) tutulur.
  late final BadgeController _badgeController; // late final : Rozet denetleyicisi; diğer iki denetleyiciyi dinleyerek rozet durumlarını hesaplar.

  @override
  void initState() { // initState() : Widget belleğe alındığında ilk çalışan yaşam döngüsü metodudur; controller'lar burada güvenli bir şekilde başlatılır.
    super.initState(); // super.initState() : Üst sınıfın başlangıç işlemlerini çalıştırır (HER ZAMAN İLK SATIRDA ÇAĞRILMALIDIR).
    _waterController = WaterTrackerController(); // Su takip controller nesnesini bellekte oluşturur.
    _workoutController = WorkoutController(); // Egzersiz controller nesnesini bellekte oluşturur.
    _badgeController = BadgeController( // BadgeController : Su ve egzersizdeki değişiklikleri anlık yakalamak için her iki controller'ı parametre olarak alır (Dependency Injection / Bağımlılık Enjeksiyonu).
      waterController: _waterController, // waterController : Su verilerini dinlemek için aktarılır.
      workoutController: _workoutController, // workoutController : Egzersiz verilerini dinlemek için aktarılır.
    );
  } // initState biter -> tüm controller'lar hazır hale gelir -> build() metoduna geçilir.

  @override
  void dispose() { // dispose() : Bu ekran tamamen kapatıldığında çalışır; arka planda açık kalan dinleyicileri (listener) temizler.
    _badgeController.dispose(); // ÖNEMLİ: Önce bağımlı olan _badgeController temizlenir ki diğer controller'lardan dinleyicilerini (removeListener) sağlıklıca çıkarsın.
    _waterController.dispose(); // _waterController içindeki ChangeNotifier kaynaklarını serbest bırakır.
    _workoutController.dispose(); // _workoutController içindeki ChangeNotifier kaynaklarını serbest bırakır.
    super.dispose(); // super.dispose() : Üst sınıfın temizlik işlemlerini tamamlar (HER ZAMAN SON SATIRDA ÇAĞRILIR).
  }

  @override
  Widget build(BuildContext context) { // build() : Sekme her değiştiğinde (setState çağrıldığında) yeniden çalışarak ilgili ekranı ve başlığı gösterir.
    final screens = [ // screens : Sekme sırasına (_currentTabIndex) göre gövdede (body) gösterilecek sayfa widget'larının listesi.
      WaterTrackerView(controller: _waterController), // 0. indeks : Su takip ekranı (kendi controller'ını dışarıdan alır).
      WorkoutView(controller: _workoutController), // 1. indeks : Egzersiz ekranı (kendi controller'ını dışarıdan alır).
      BadgeView(controller: _badgeController), // 2. indeks : Rozetler ekranı (kendi controller'ını dışarıdan alır).
    ];

    const titles = [ // const titles : Seçili sekmeye göre AppBar'da yazacak olan sabit başlık metinleri listesi.
      'Susadım • Su Takibi', // 0. sekme başlığı
      'Susadım • Egzersiz', // 1. sekme başlığı
      'Susadım • Rozetler', // 2. sekme başlığı
    ];

    return Scaffold( // Scaffold : Sayfanın temel görsel iskeletini (appBar, body, bottomNavigationBar) kuran ana Material bileşeni.
      appBar: AppBar( // appBar : Ekranın en üstündeki başlık çubuğu.
        title: Row( // Row : Logo ve başlık metnini yatayda (yan yana) dizmek için kullanılır.
          children: [
            Container( // Container : Logonun etrafına kenarlık (border), köşe yuvarlatma ve neon parlama (boxShadow) ekleyen kutu.
              decoration: BoxDecoration( // BoxDecoration : Container'ın görsel süsleme ayarlarını tutar.
                borderRadius: BorderRadius.circular(10), // BorderRadius.circular(10) : Kutunun köşelerini 10 birim yuvarlatır.
                border: Border.all(color: AppColors.cardBorder, width: 1), // Border.all : Kutunun dört tarafına 1 piksel kalınlığında koyu gri çerçeve çizer.
                boxShadow: [ // boxShadow : Kutunun arkasına gölge/parlama efekti verir.
                  BoxShadow(
                    color: AppColors.neonCyan.withValues(alpha: 0.25), // withValues(alpha: 0.25) : Neon camgöbeği rengini %25 görünürlükle (yarı saydam) uygular.
                    blurRadius: 10, // blurRadius: 10 : Işığın dağılma/bulanıklık yarıçapını belirler.
                  ),
                ],
              ),
              child: ClipRRect( // ClipRRect : İçindeki resmi (Image.asset) yuvarlatılmış köşelere göre kırpar (resmin çerçeveden taşmasını önler).
                borderRadius: BorderRadius.circular(9), // Dış çerçeveden (10) 1 piksel küçük verilerek kenarlıkla tam uyum sağlanır.
                child: Image.asset( // Image.asset : Proje dosyaları (assets) içindeki yerel bir görseli ekrana çizer.
                  'assets/images/logo.png', // Görselin pubspec.yaml'da tanımlı dosya yolu.
                  width: 32, // Genişlik : 32 piksel.
                  height: 32, // Yükseklik : 32 piksel.
                  fit: BoxFit.cover, // BoxFit.cover : Görselin en-boy oranını bozmadan 32x32'lik alanı tamamen doldurmasını sağlar.
                ),
              ),
            ),
            const SizedBox(width: 12), // SizedBox(width: 12) : Logo ile başlık metni arasına yatayda 12 piksellik boşluk bırakır.
            Expanded( // Expanded : Row içinde kalan tüm boş yatay alanı kaplar; böylece uzun başlıkların ekran dışına taşmasını (overflow hatasını) engeller.
              child: Text(
                titles[_currentTabIndex], // titles[_currentTabIndex] : Aktif sekme indeksine karşılık gelen başlığı listeden seçip yazar.
                overflow: TextOverflow.ellipsis, // TextOverflow.ellipsis : Metin sığmazsa sonuna "..." (üç nokta) koyarak keser.
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(child: screens[_currentTabIndex]), // SafeArea : Telefonun çentik (notch), durum çubuğu veya alt barı gibi sistem alanlarına içeriğin girmesini engeller | screens[_currentTabIndex] : Seçili ekranı gösterir.
      bottomNavigationBar: NavigationBar( // NavigationBar : Ekranın altındaki Material 3 uyumlu sekme geçiş çubuğu.
        selectedIndex: _currentTabIndex, // selectedIndex : Şu an hangi sekmenin aktif olarak işaretleneceğini belirler.
        onDestinationSelected: (index) => setState(() => _currentTabIndex = index), // onDestinationSelected : Kullanıcı bir sekmeye tıkladığında tıklanan sırayı (index) verir | setState() : _currentTabIndex değerini günceller ve sadece bu kabuk widget'ın build metodunu yeniden tetikler.
        destinations: const [ // destinations : Alt barda yer alacak sekme butonlarının (NavigationDestination) listesi.
          NavigationDestination( // 1. Sekme : Su Takibi
            icon: Icon(Icons.water_drop_outlined), // icon : Sekme seçili DEĞİLKEN gösterilecek içi boş su damlası ikonu.
            selectedIcon: Icon(Icons.water_drop_rounded), // selectedIcon : Sekme SEÇİLİYKEN gösterilecek içi dolu su damlası ikonu.
            label: 'Su Takibi', // label : İkonun altında yazan sekme etiketi.
          ),
          NavigationDestination( // 2. Sekme : Egzersiz
            icon: Icon(Icons.fitness_center_outlined), // Seçili değilken içi boş dambıl ikonu.
            selectedIcon: Icon(Icons.fitness_center_rounded), // Seçiliyken dolgulu dambıl ikonu.
            label: 'Egzersiz',
          ),
          NavigationDestination( // 3. Sekme : Rozetler
            icon: Icon(Icons.military_tech_outlined), // Seçili değilken içi boş madalya ikonu.
            selectedIcon: Icon(Icons.military_tech_rounded), // Seçiliyken dolgulu madalya ikonu.
            label: 'Rozetler',
          ),
        ],
      ),
    );
  }
}

// ÇALIŞMA MANTIĞI: main() çağrılır -> SusadimApp (MaterialApp + Tema) kurulur -> MainNavigationShell initState() içinde 3 Controller oluşturulur -> Kullanıcı alt menüden sekme seçer -> setState() ile _currentTabIndex değişir -> İlgili ekran (screens[_currentTabIndex]) aynı controller referansıyla kayıpsız çizilir.

// STATELESSWIDGET : İçinde değişen bir veri (state) tutmaz, sadece dışarıdan gelen parametrelerle bir kez çizilir (Örn: SusadimApp).
//  VS
// STATEFULWIDGET : Yaşam döngüsü (initState, dispose) vardır ve içindeki veri değiştiğinde setState() ile kendi arayüzünü yeniden çizebilir (Örn: MainNavigationShell).
