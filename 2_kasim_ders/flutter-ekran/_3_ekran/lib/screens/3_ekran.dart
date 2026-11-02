import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SepetKontrolu {
  static final SepetKontrolu ornek = SepetKontrolu._dahili();
  SepetKontrolu._dahili();

  final ValueNotifier<int> urunSayisi = ValueNotifier<int>(0);

  void sepeteEkle() {
    urunSayisi.value++;
  }

  void sepetSifirla() {
    urunSayisi.value = 0;
  }
}

final GoRouter uygulamaRotalari = GoRouter(
  initialLocation: '/anasayfa',
  routes: [
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return AnaKasaEkrani(ekranGovdesi: child);
      },
      routes: [
        GoRoute(
          path: '/vitrin',
          builder: (context, state) => const VitrinEkrani(),
        ),
        GoRoute(
          path: '/anasayfa',
          builder: (context, state) => const AnasayfaEkrani(),
        ),
        GoRoute(
          path: '/profil',
          builder: (context, state) => const ProfilEkrani(),
        ),
      ],
    ),
  ],
);

//Statefull:komple yenileme stateless: widget yenilenmez içindeki veri yenilenir
class AnaKasaEkrani extends StatelessWidget {
  final Widget ekranGovdesi;
  const AnaKasaEkrani({super.key, required this.ekranGovdesi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ekranGovdesi,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _aktifIndexiBul(context),
        onDestinationSelected: (yeniIndex) {
          if (yeniIndex == 0) context.go('/vitrin');
          if (yeniIndex == 1) context.go('/anasayfa');
          if (yeniIndex == 2) context.go('/profil');
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.store),
            label: 'Vitrin',
          ),
          const NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Anasayfa',
          ),
          NavigationDestination(
            icon: ValueListenableBuilder<int>(
              valueListenable: SepetKontrolu.ornek.urunSayisi,
              builder: (context, sayi, child) {
                return Badge(
                  label: Text('$sayi'),
                  isLabelVisible: sayi > 0,
                  child: const Icon(Icons.person),
                );
              },
            ),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  int _aktifIndexiBul(BuildContext context) {
    final String konum = GoRouterState.of(context).uri.toString();
    if (konum.startsWith('/anasayfa')) return 1;
    if (konum.startsWith('/profil')) return 2;
    return 0; // /vitrin
  }
}

class VitrinEkrani extends StatelessWidget {
  const VitrinEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canlı Vitrin (ValueNotifier)'),
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            SepetKontrolu.ornek.sepeteEkle();
          },
          icon: const Icon(Icons.add_shopping_cart),
          label: const Text('Sepete Ürün Ekle'),
        ),
      ),
    );
  }
}

class AnasayfaEkrani extends StatelessWidget {
  const AnasayfaEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anasayfa'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home, size: 64, color: Colors.blue),
            const SizedBox(height: 16),
            const Text(
              'Uygulamaya Hoş Geldiniz!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ValueListenableBuilder<int>(
              valueListenable: SepetKontrolu.ornek.urunSayisi,
              builder: (context, sayi, child) {
                return Text(
                  'Sepetinizdeki Ürün Sayısı: $sayi',
                  style: const TextStyle(fontSize: 16),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilEkrani extends StatelessWidget {
  const ProfilEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kullanıcı Profili'),
      ),
      body: Center(
        child: TextButton.icon(
          onPressed: () {
            SepetKontrolu.ornek.sepetSifirla();
          },
          icon: const Icon(Icons.delete_outline),
          label: const Text('Sepeti Temizle (0 yap)'),
        ),
      ),
    );
  }
}
