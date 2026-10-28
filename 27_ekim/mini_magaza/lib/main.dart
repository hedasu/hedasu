import 'package:flutter/material.dart';
import 'package:mini_magaza/screens/urun_listesi_ekrani.dart';

void main() {
  runApp(const MiniMagazaUygulamasi());
}

class MiniMagazaUygulamasi extends StatelessWidget {
  // StatelessWidget : Uygulamaın tamamını DEĞİŞMEYEN YAPI için kullanılır
  const MiniMagazaUygulamasi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Mini Mağaza",
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          // seed:tohum varsayılan değerler
          seedColor: Colors.indigo,
          brightness: Brightness.light, //Açık renk
        ),
      ),

      home: const UrunListesiEkrani(),
    );
  }
}
