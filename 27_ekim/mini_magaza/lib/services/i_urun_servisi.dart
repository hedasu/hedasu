import '../models/category.dart';
import '../models/urun.dart';

abstract class IUrunServisi {
  Future<List<Urun>> tumUrunleriGetir(); // async kullanmak için Future

  Future<List<Urun>> kategoriyeGoreGetir(Category kategori);

  Future<List<Urun>> adaGoreAra(String aramaMetni);
}
