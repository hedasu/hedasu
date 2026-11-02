import 'package:flutter/material.dart';
import '../urun_modeli.dart';

class UrunEkrani extends StatefulWidget {
  const UrunEkrani({super.key});

  @override
  State<UrunEkrani> createState() => _UrunEkraniState();
}

class _UrunEkraniState extends State<UrunEkrani> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürünler'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text('Ürünler'),
      ),
      
    );
  }
}