
import 'package:flutter/material.dart';

// Oluşturduğumuz ekranlar
import 'screens/01_layout_screen.dart';
import 'screens/02_market_list_screen.dart';
import 'screens/03_transfer_form_screen.dart';

void main() {
  runApp(const DtmMAsterApp());
}

class DtmMAsterApp extends StatelessWidget {
  const DtmMAsterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "DTM Flutter Sınıfı",
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
      ),

      // Uygulamanın ilk açılacak ekranı
      home: const LiveCanvasScreen(),
    );
  }
}

class LiveCanvasScreen extends StatelessWidget {
  const LiveCanvasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),

        appBar: AppBar(
          title: const Text(
            "DTM Canlı Arayüz",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,

          actions: [
            IconButton(
              icon: const Icon(
                Icons.notifications_active_outlined,
              ),
              onPressed: () {},
            ),
          ],

          // Ekranlar arasında geçiş yapmak için
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.dashboard_outlined),
                text: 'Arayüz',
              ),
              Tab(
                icon: Icon(Icons.currency_bitcoin),
                text: 'Piyasalar',
              ),
              Tab(
                icon: Icon(Icons.send_outlined),
                text: 'Transfer',
              ),
            ],
          ),
        ),

        // Oluşturduğumuz ekranları bağlıyoruz
        body: const TabBarView(
          children: [
            LayoutStylingScreen(),
            MarketsGridListScreen(),
            TransferFormScreen(),
          ],
        ),
      ),
    );
  }
}
