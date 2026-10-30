import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/urun.dart';
import '../services/i_urun_servisi.dart';
import '../services/mock_urun_servisi.dart';
import '../widget/urun_karti.dart';

class UrunListesiEkrani extends StatefulWidget {
  const UrunListesiEkrani({super.key});

  @override
  State<UrunListesiEkrani> createState() => _UrunListesiEkraniState(); // State:depo olarak görev yapıyor ve verileri saklıyor
}

class _UrunListesiEkraniState extends State<UrunListesiEkrani> {
  final IUrunServisi _servis = MockUrunServisi();

  final TextEditingController _aramaController = TextEditingController();

  bool _yukleniyorMu = true;
  Category _seciliKategori = Category.hepsi;
  List<Urun> _filtrelenmisUrunler = [];
  List<Urun> _tumUrunler = [];

  @override
  void initState() {
    //widget ilk kez oluşturulduğunda burası çalışır
    super.initState();
    _urunleriYukle();
  }

  @override
  void dispose() {
    _aramaController.dispose(); //belleği boşalt
    super.dispose();
  }

  Future<void> _urunleriYukle() async {
    setState(() {
      _yukleniyorMu = true;
    });

    final urunler = await _servis.kategoriyeGoreGetir(_seciliKategori);

    if (mounted) {
      setState(() {
        _tumUrunler = urunler;
        _filtrelenmisUrunler = urunler;
        _yukleniyorMu = false;
      });
    }
  }

  void _filtreyiUygula() {
    final aranan = _aramaController.text.trim().toLowerCase();

    setState(() {
      _filtrelenmisUrunler = _tumUrunler.where((urun) {
        final kategoriUygunMu =
            (_seciliKategori == Category.hepsi ||
            urun.kategori == _seciliKategori);

        final aramaUygunMu =
            aranan.isEmpty || urun.baslik.toLowerCase().contains(aranan);
        return kategoriUygunMu && aramaUygunMu;
      }).toList(); //array halinde gelen bilgilerin nasıl gelmesi gerektiğini bildiriyoruz
    });
  }

  void _favoriDegistir(Urun hedefUrun) {
    setState(() {
      final yeniUrun = hedefUrun.copywith(favoriMi: !hedefUrun.favoriMi);
      final index = _tumUrunler.indexWhere((u) => u.id == hedefUrun.id);
      if (index != -1) {
        _tumUrunler[index] = yeniUrun;
      }
      _filtreyiUygula();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mini Mağaza",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Badge(
                label: Text(
                  '${_tumUrunler.where((u) => u.favoriMi).length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                child: const Icon(Icons.favorite, color: Colors.red),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextField(
              controller: _aramaController,
              onChanged: (_) => _filtreyiUygula(),
              decoration: InputDecoration(
                hintText: "Ürün veya Marka ara ...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _aramaController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _aramaController.clear();
                          _filtreyiUygula();
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: Category.values.map((kategori) {
                //map:döngü
                final seciliMi = _seciliKategori == kategori;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    avatar: Text(kategori.icon),
                    label: Text(kategori.baslik),
                    selected: seciliMi,
                    onSelected: (secildi) {
                      if (secildi) {
                        setState(() {
                          _seciliKategori = kategori;
                          _filtreyiUygula();
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          Expanded(
            child: _yukleniyorMu
                ? const Center(child: CircularProgressIndicator())
                : _filtrelenmisUrunler.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Aradığınız kriterlere uygun ürün bulunamadı.',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _filtrelenmisUrunler.length,
                    itemBuilder: (context, index) {
                      final urun = _filtrelenmisUrunler[index];
                      return UrunKarti(
                        urun: urun,
                        onFavoriTiklandi: () => _favoriDegistir(urun),
                        onDetayTiklandi: () => {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${urun.baslik} tıklandı!'),
                              duration: const Duration(milliseconds: 600),
                            ),
                          ),
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
