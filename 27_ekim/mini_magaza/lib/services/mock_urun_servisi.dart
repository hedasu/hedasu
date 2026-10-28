import 'i_urun_servisi.dart';
import '../models/category.dart';
import '../models/urun.dart';

class MockUrunServisi implements IUrunServisi {
  //interface sözleşmesinden devam edeceğimiz için implement kullandık

  final List<Urun> _urunDeposu = const [
    Urun(
      id: 1,
      baslik: "Macbook M5 Pro Laptop",
      aciklama: "14 inç M5 Pro çipli, 16 GB RAM",
      fiyat: 179999.0,
      resimUrl: "https://picsum.photos/400/400", // 400 400 size
      kategori: Category.elektronik,
      stokAdedi: 5,
    ),
    Urun(
      id: 2,
      baslik: "Apple İphone 18 Pro Max",
      aciklama: "A18 Pro çip, 12 GB RAM, 256 GB Depolama",
      fiyat: 149999.0,
      resimUrl: "https://picsum.photos/400/400", // 400 400 size
      kategori: Category.elektronik,
      stokAdedi: 12,
    ),
    Urun(
      id: 3,
      baslik: "Erkek L Gömlek",
      aciklama: "%100 Pamuk, Slim Fit, Mavi",
      fiyat: 499.0,
      resimUrl: "https://picsum.photos/400/400", // 400 400 size
      kategori: Category.giyim,
      stokAdedi: 102,
    ),
    Urun(
      id: 4,
      baslik: "Unisex Mavi Sweatshirt",
      aciklama: "Unisex, %100 Pamuk, Mavi",
      fiyat: 599.0,
      resimUrl: "https://picsum.photos/400/400", // 400 400 size
      stokAdedi: 150,
      kategori: Category.giyim,
    ),
    Urun(
      id: 5,
      baslik: "Süet Omuz Çantası",
      aciklama: "Kadın, %100 Pamuk, Siyah",
      fiyat: 1199.0,
      resimUrl: "https://picsum.photos/400/400", // 400 400 size
      stokAdedi: 150,
      kategori: Category.aksesuar,
    ),
    Urun(
      id: 6,
      baslik: "Airpods Pro 3",
      aciklama: "Hızlı şarj, gürültü engelleme, su geçirmez",
      fiyat: 7999.0,
      resimUrl: "https://picsum.photos/400/400", // 400 400 size
      stokAdedi: 120,
      kategori: Category.elektronik,
    ),
    Urun(
      id: 7,
      baslik: "Apple Watch Series 9",
      aciklama: "GPS, 41 mm, Alüminyum",
      fiyat: 179999.0,
      resimUrl: "https://picsum.photos/400/400", // 400 400 size
      stokAdedi: 5,
      kategori: Category.elektronik,
    ),
    Urun(
      id: 8,
      baslik: "Kadın Beyaz Sneaker",
      aciklama: "Deri, %100 Pamuk, Beyaz",
      fiyat: 999.0,
      resimUrl: "https://picsum.photos/400/400", // 400 400 size
      stokAdedi: 150,
      kategori: Category.ayakkabi,
    ),
    Urun(
      id: 9,
      baslik: "Erkek Deri Ceket",
      aciklama: "Gerçek dana derisi, %100 Pamuk",
      fiyat: 2999.0,
      resimUrl: "https://picsum.photos/400/400", // 400 400 size
      stokAdedi: 45,
      kategori: Category.giyim,
    ),
  ];

  @override
  Future<List<Urun>> tumUrunleriGetir() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return List.from(_urunDeposu);
  }

  @override
  Future<List<Urun>> kategoriyeGoreGetir(Category kategori) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (kategori == Category.hepsi) {
      return List.from(_urunDeposu);
    }
    return _urunDeposu.where((urun) => urun.kategori == kategori).toList();
  }

  @override
  Future<List<Urun>> adaGoreAra(String aramaMetni) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (aramaMetni.trim().isEmpty) {
      // .trim: boşlukları atar .isEmpty: boş mu diye bakar
      return List.from(_urunDeposu);
    }
    return _urunDeposu.where((urun) {
      final baslikKucuk = urun.baslik.toLowerCase();
      final arananKucuk = aramaMetni.toLowerCase();
      return baslikKucuk.contains(arananKucuk); //contains: içeriyor mu kontrolü
    }).toList();
  }
}
