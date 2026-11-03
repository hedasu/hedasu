// -bu kod bloğunda uygulamanın başlangıç noktası (main), kök widget'ı (SusadimApp), dinamik tema yönetimi, sekme (tab) kontrolü ve rozet bildirim dinleyicisi anlatılıyor.-
// ValueNotifier<T>: İçinde tek bir değer tutan ve bu değer değiştiğinde dinleyicilerine (UI'a) haber veren reaktif yapı.
// ValueListenableBuilder<T>: Bir ValueNotifier'ı dinleyerek, tüm ekranı yeniden çizmek (setState) yerine SADECE ilgili widget parçasını yeniden oluşturan widget.
// IndexedStack: İçindeki tüm alt sayfaları aynı anda bellekte ve ağaçta tutan, ancak ekranda sadece seçili 'index'teki sayfayı gösteren yapı. (Sayfa değiştirince veriler/kaydırma konumu sıfırlanmaz).
// StatefulWidget: Yaşam döngüsü (initState, dispose) olan veya zamanla değişebilen durumları barındıran widget.

import 'package:flutter/material.dart'; // Flutter'ın Material Design görsel bileşenlerini (Scaffold, AppBar, MaterialApp vb.) projeye dahil eder.
import 'core/constants/app_colors.dart'; // Uygulamanın karanlık ve aydınlık tema renk sabitlerini barındıran dosya.
import 'core/theme/app_theme.dart'; // ThemeData (açık ve koyu tema ayarları) yapılandırmasını içeren dosya.
import 'core/theme/theme_controller.dart'; // Tema değişimini (Karanlık <-> Aydınlık) ValueNotifier ile yöneten kontrolcü.
import 'features/badges/controllers/badge_controller.dart'; // Rozet kazanma mantığını ve rozet listesini yöneten kontrolcü.
import 'features/badges/view/badge_view.dart'; // Rozetlerin sergilendiği ekran arayüzü.
import 'features/water_tracker/controllers/water_tracker_controller.dart'; // Su ekleme, çıkarma (undo) ve hedef hesaplamalarını yapan kontrolcü.
import 'features/water_tracker/view/water_tracker_view.dart'; // Su takip ekranı arayüzü.
import 'features/workout/controllers/workout_controller.dart'; // Egzersiz ekleme, geri alma ve kalori/dakika hesaplamalarını yapan kontrolcü.
import 'features/workout/view/workout_view.dart'; // Egzersiz takip ekranı arayüzü.

void main() { // main(): Dart ve Flutter uygulamasının ilk çalışmaya başladığı ana giriş fonksiyonu. | void: geriye bir değer döndürmez.
  WidgetsFlutterBinding.ensureInitialized(); // Uygulama başlamadan önce Flutter motoru (engine) ile widget katmanı arasındaki bağın hazır olduğundan emin olur. (Özel başlangıç işlemleri için güvenlik önlemi).
  runApp(const SusadimApp()); // runApp(): Verilen widget'ı tüm ekranı kaplayacak şekilde kök (root) widget olarak başlatır. | const: derleme zamanı sabiti (performans sağlar).
}

/// Susadım v1 - Ana Uygulama Kökü (Dinamik Tema Destekli)
class SusadimApp extends StatefulWidget { // SusadimApp: Uygulamanın en üst sarmalayıcı sınıfı. | StatefulWidget: ThemeController'ı oluşturmak ve uygulama kapanırken dispose etmek için kullanılır.
  const SusadimApp({super.key}); // const kurucu metot. | super.key: Widget'ın ağaçtaki kimliğini üst sınıfa (StatefulWidget) iletir.

  @override // Üst sınıftaki createState metodunu kendi sınıfımıza göre yeniden yazdığımızı belirtir.
  State<SusadimApp> createState() => _SusadimAppState(); // createState(): Bu StatefulWidget için durum ve yaşam döngüsünü yönetecek State nesnesini oluşturur.
}

class _SusadimAppState extends State<SusadimApp> { // _: Sadece bu dosya içinde erişilebilen (private) State sınıfı.
  late final ThemeController _themeController; // late: Değişkene hemen değil, kullanımdan hemen önce (initState içinde) değer atanacağını garanti eder. | final: Bir kez atandıktan sonra başka bir nesneyle değiştirilemez.

  @override
  void initState() { // initState(): State nesnesi oluşturulduğunda SADECE BİR KEZ çalışır. Başlangıç atamaları burada yapılır.
    super.initState(); // Üst sınıfın başlangıç işlemlerini çalıştırır (her zaman ilk satırda çağrılmalıdır).
    _themeController = ThemeController(); // Tema durumunu yönetecek kontrolcü nesnesi oluşturulur ve belleğe alınır.
  }

  @override
  void dispose() { // dispose(): Widget ağaçtan kalıcı olarak kaldırıldığında çalışır. Bellek sızıntısını (memory leak) önlemek için kullanılır.
    _themeController.dispose(); // ThemeController içindeki ValueNotifier'ı bellekten temizler.
    super.dispose(); // Üst sınıfın temizlik işlemlerini tamamlar (her zaman son satırda çağrılır).
  }

  @override
  Widget build(BuildContext context) { // build(): Arayüzü çizen metot. | BuildContext: Widget'ın ağaçtaki konum bilgisini tutar.
    return ValueListenableBuilder<ThemeMode>( // ThemeController içindeki themeMode değiştiğinde sadece MaterialApp'i yeniden oluşturur.
      valueListenable: _themeController.themeMode, // valueListenable: Dinlenecek olan veri kaynağı (ValueNotifier<ThemeMode>).
      builder: (context, activeMode, _) { // builder: Veri her değiştiğinde çalışan fonksiyon. | activeMode: O anki güncel ThemeMode (dark veya light). | _: Yeniden çizilmeyen sabit alt widget (kullanılmadığı için _ verildi).
        return MaterialApp( // MaterialApp: Uygulamanın tema, başlık, navigasyon ve ana ekran ayarlarını barındıran temel yapı taşı.
          title: 'Susadım v1', // Cihazın görev yöneticisinde (son kullanılan uygulamalar) görünen uygulama adı.
          debugShowCheckedModeBanner: false, // Sağ üst köşedeki kırmızı "DEBUG" şeridini gizler.
          theme: AppTheme.lightTheme, // Aydınlık mod seçildiğinde uygulanacak tasarım kuralları.
          darkTheme: AppTheme.darkTheme, // Karanlık mod seçildiğinde uygulanacak tasarım kuralları.
          themeMode: activeMode, // Hangi temanın aktif olacağını belirler (activeMode değiştikçe uygulama anında tema değiştirir).
          home: SusadimHomePage(themeController: _themeController), // Uygulama açıldığında ilk gösterilecek ana sayfa widget'ı. Контроlcüyü parametre olarak aktarır.
        );
      },
    );
  }
}

/// Ana Sayfa ve Sekme Yönetimi
class SusadimHomePage extends StatefulWidget { // Alt navigasyon (BottomNavigationBar) ve 3 ana ekranı barındıran ana sayfa.
  final ThemeController themeController; // Üst widget'tan gelen tema kontrolcüsü.

  const SusadimHomePage({
    super.key,
    required this.themeController, // required: Bu widget çağrılırken themeController parametresinin verilmesi ZORUNLUDUR.
  });

  @override
  State<SusadimHomePage> createState() => _SusadimHomePageState();
}

class _SusadimHomePageState extends State<SusadimHomePage> {
  late final BadgeController _badgeController; // Rozetleri yönetecek kontrolcü.
  late final WaterTrackerController _waterController; // Su takibini yönetecek kontrolcü.
  late final WorkoutController _workoutController; // Egzersizleri yönetecek kontrolcü.
  final ValueNotifier<int> _currentTab = ValueNotifier<int>(0); // Aktif sekme indeksini tutan reaktif değişken. (0: Su Takibi, 1: Egzersiz, 2: Rozetler).

  @override
  void initState() {
    super.initState();
    _badgeController = BadgeController(); // Önce rozet kontrolcüsü oluşturulur çünkü diğer iki kontrolcü rozetleri tetiklemek için buna ihtiyaç duyar.
    _waterController = WaterTrackerController(badgeController: _badgeController); // Su kontrolcüsüne rozet kontrolcüsü bağlanır (Dependency Injection / Bağımlılık Enjeksiyonu).
    _workoutController = WorkoutController(badgeController: _badgeController); // Egzersiz kontrolcüsüne rozet kontrolcüsü bağlanır.

    _badgeController.lastUnlockedBadgeNotification.addListener(_onBadgeUnlocked); // addListener(): Yeni bir rozet kazanıldığında _onBadgeUnlocked fonksiyonunu otomatik çalıştırmak için dinleyici ekler.
  }

  void _onBadgeUnlocked() { // Rozet kilidi açıldığında tetiklenen geri çağırım (callback) fonksiyonu.
    final title = _badgeController.lastUnlockedBadgeNotification.value; // Kazanılan son rozetin başlığını alır (String? - null olabilir).
    if (title != null && mounted) { // Başlık boş değilse VE bu widget hala ekranda aktifse (mounted == true) bildirim göster. | ÖNEMLİ: mounted kontrolü, ekran kapandıysa hata almayı önler.
      ScaffoldMessenger.of(context).showSnackBar( // Ekranın altından kayarak çıkan bilgi çubuğu (SnackBar) gösterir.
        SnackBar(
          content: Row( // İkon ve metni yan yana dizmek için Row kullanılır.
            children: [
              Icon(Icons.military_tech_rounded, color: AppColors.goldOf(context)), // Madalya ikonu, temaya uygun altın renginde.
              const SizedBox(width: 10), // İkon ile yazı arasına 10 piksel yatay boşluk.
              Expanded( // Expanded: Yazı uzun olursa ekrandan taşmasını (overflow) engeller, kalan boşluğa sığdırır.
                child: Text(
                  'Tebrikler! Yeni Rozet: $title', // $title: String interpolation ile rozet adını metne gömer.
                  style: TextStyle(
                    color: AppColors.textPrimaryOf(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 3), // Bildirimin ekranda kalacağı süre (3 saniye).
        ),
      );
      _badgeController.clearNotification(); // Bildirim gösterildikten sonra aynı bildirimin tekrar çıkmaması için değeri sıfırlar (null yapar).
    }
  }

  @override
  void dispose() { // Sayfa kapandığında tüm dinleyicileri ve kontrolcüleri bellekten temizler.
    _badgeController.lastUnlockedBadgeNotification.removeListener(_onBadgeUnlocked); // Eklenen özel dinleyiciyi kaldırır.
    _badgeController.dispose(); // Rozet kontrolcüsünü kapatır.
    _waterController.dispose(); // Su kontrolcüsünü kapatır.
    _workoutController.dispose(); // Egzersiz kontrolcüsünü kapatır.
    _currentTab.dispose(); // Sekme sayacını kapatır.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Scaffold: Sayfanın temel görsel iskeleti (AppBar, Body, BottomNavigationBar).
      appBar: _SusadimAppBar(themeController: widget.themeController), // Üst başlık çubuğu. | widget.themeController: Üst sınıftaki (SusadimHomePage) değişkene erişir.
      body: ValueListenableBuilder<int>( // _currentTab değiştikçe sadece gövdeyi (body) günceller.
        valueListenable: _currentTab,
        builder: (context, activeIndex, _) { // activeIndex: Seçili olan sekmenin numarası (0, 1 veya 2).
          return IndexedStack( // IndexedStack: Çocuklardan sadece 'index' ile eşleşeni gösterir ama diğerlerinin durumunu (state) korur.
            index: activeIndex,
            children: [
              WaterTrackerView(controller: _waterController), // İndeks 0: Su Takip Ekranı.
              WorkoutView(controller: _workoutController), // İndeks 1: Egzersiz Ekranı.
              BadgeView(controller: _badgeController), // İndeks 2: Rozet Vitrini Ekranı.
            ],
          );
        },
      ),
      bottomNavigationBar: ValueListenableBuilder<int>( // Alt menüdeki seçili ikonu güncellemek için _currentTab'ı dinler.
        valueListenable: _currentTab,
        builder: (context, activeIndex, _) {
          return _SusadimBottomNav(
            currentIndex: activeIndex, // Şu an hangi sekmenin aktif olduğunu alt menüye bildirir.
            onTap: (index) => _currentTab.value = index, // Kullanıcı bir sekmeye tıkladığında _currentTab değerini yeni indekse eşitler -> UI otomatik güncellenir.
          );
        },
      ),
    );
  }
}

class _SusadimAppBar extends StatelessWidget implements PreferredSizeWidget { // Özel AppBar widget'ı. | implements PreferredSizeWidget: Scaffold'un appBar parametresine verilebilmesi için yükseklik (preferredSize) belirtme sözleşmesini uygular.
  final ThemeController themeController;

  const _SusadimAppBar({required this.themeController});

  @override
  Size get preferredSize => const Size.fromHeight(60); // AppBar'ın yüksekliğini 60 piksel olarak sabitler.

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context); // Şu anki temanın karanlık mod olup olmadığını kontrol eder (true/false).

    return AppBar(
      title: Row( // Logo ve uygulama adını yan yana koyar.
        children: [
          ClipRRect( // ClipRRect: İçindeki resmi yuvarlatılmış köşelerle kırpar.
            borderRadius: BorderRadius.circular(8), // 8 piksellik köşe yuvarlatma.
            child: Image.asset( // Proje içindeki yerel resmi (assets) ekrana çizer.
              'assets/images/logo.png',
              width: 32,
              height: 32,
              fit: BoxFit.cover, // Resmi kutuya taşmadan ve oranını bozmadan doldurur.
            ),
          ),
          const SizedBox(width: 10),
          const Text('Susadım v1'), // Uygulama başlığı.
        ],
      ),
      actions: [ // AppBar'ın sağ tarafında yer alacak aksiyon butonları.
        Padding(
          padding: const EdgeInsets.only(right: 14), // Sağ kenardan 14 piksel iç boşluk.
          child: InkWell( // InkWell: Tıklanabilir alan oluşturur ve tıklandığında su dalgası (ripple) efekti verir.
            onTap: themeController.toggleTheme, // Tıklandığında temayı Karanlık <-> Aydınlık arasında değiştirir.
            borderRadius: BorderRadius.circular(12), // Dalga efektinin köşelerini yuvarlatır.
            child: Container( // Butonun dış çerçevesi ve arka planı.
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), // Yatayda 10, dikeyde 6 piksel iç boşluk.
              decoration: BoxDecoration(
                color: AppColors.surfaceLightOf(context), // Temaya göre değişen yüzey rengi.
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.surfaceBorderOf(context)), // İnce kenarlık çizgisi.
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min, // Row'un tüm satırı kaplamasını engeller, sadece içindekiler kadar yer kaplar.
                children: [
                  Icon(
                    isDark ? Icons.nightlight_round : Icons.wb_sunny_rounded, // Karanlık moddaysa Ay ikonu, aydınlık moddaysa Güneş ikonu. (Ternary Operator: koşul ? doğruysa : yanlışsa).
                    color: isDark ? AppColors.neonCyan : AppColors.neonOrange, // Karanlıkta neon mavi, aydınlıkta neon turuncu.
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isDark ? 'Karanlık' : 'Aydınlık', // Aktif tema modunun adını yazar.
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimaryOf(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SusadimBottomNav extends StatelessWidget { // Alt gezinme çubuğunu (NavigationBar) oluşturan modüler StatelessWidget.
  final int currentIndex; // Aktif sekme numarası.
  final ValueChanged<int> onTap; // ValueChanged<int>: Parametre olarak int alan ve geriye değer döndürmeyen (void Function(int)) fonksiyon tipi.

  const _SusadimBottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cyan = AppColors.cyanOf(context); // Su sekmesi vurgu rengi.
    final green = AppColors.greenOf(context); // Egzersiz sekmesi vurgu rengi.
    final gold = AppColors.goldOf(context); // Rozet sekmesi vurgu rengi.
    final muted = AppColors.textSecondaryOf(context); // Seçili olmayan sekmelerin soluk rengi.

    return NavigationBar( // Material 3 standartlarındaki modern alt menü çubuğu.
      selectedIndex: currentIndex, // Hangi sekmenin seçili görüneceğini belirler.
      onDestinationSelected: onTap, // Bir sekmeye basıldığında tıklanan indeksi üst widget'a iletir.
      backgroundColor: AppColors.surfaceOf(context),
      indicatorColor: AppColors.surfaceLightOf(context), // Seçili ikonun arkasındaki hap şeklindeki vurgu rengi.
      destinations: [ // Alt menüdeki 3 sekme öğesi.
        NavigationDestination(
          icon: Icon(Icons.water_drop_outlined, color: muted), // Seçili değilken içi boş damla ikonu.
          selectedIcon: Icon(Icons.water_drop_rounded, color: cyan), // Seçiliyken içi dolu mavi damla ikonu.
          label: 'Su Takibi',
        ),
        NavigationDestination(
          icon: Icon(Icons.fitness_center_outlined, color: muted), // Seçili değilken soluk dambıl ikonu.
          selectedIcon: Icon(Icons.fitness_center_rounded, color: green), // Seçiliyken yeşil dambıl ikonu.
          label: 'Egzersiz',
        ),
        NavigationDestination(
          icon: Icon(Icons.military_tech_outlined, color: muted), // Seçili değilken soluk madalya ikonu.
          selectedIcon: Icon(Icons.military_tech_rounded, color: gold), // Seçiliyken altın madalya ikonu.
          label: 'Rozetler',
        ),
      ],
    );
  }
}

// ÇALIŞMA MANTIĞI:
// main() başlar -> SusadimApp oluşturulur -> ThemeController başlatılır -> SusadimHomePage açılır
// -> Su/Egzersiz/Rozet kontrolcüleri birbirine bağlanır -> Kullanıcı alt menüden sekme seçer (_currentTab değişir)
// -> IndexedStack ilgili ekranı gösterir -> Kullanıcı su veya egzersiz eklediğinde rozet şartı sağlanırsa
// -> lastUnlockedBadgeNotification tetiklenir -> _onBadgeUnlocked çalışır -> Ekranda SnackBar ile tebrik mesajı gösterilir.

// STATEFULWIDGET + SETSTATE : Tüm widget ağacını yeniden çizer, büyük ekranlarda performans kaybına yol açabilir
//  VS
// STATELESSWIDGET + VALUELISTENABLEBUILDER : Sadece dinlenen ValueNotifier değiştiğinde ilgili küçük widget bloğunu yeniden çizer, çok daha performanslıdır
