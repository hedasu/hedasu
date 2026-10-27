import 'category.dart';


class Urun{
    final int id;
    final String baslik;
    final String aciklama;
    final double fiyat;
    final String resimUrl;
    final Category kategori;
    final int stokAdedi;
    final bool favoriMi;


    const Urun({
        required this.id,
        required this.baslik,
        required this.aciklama,
        required this.fiyat,
        required this.resimUrl,
        required this.kategori,
        required this.stokAdedi,
        this.favoriMi = false,
    });

    Urun copywith({ //favori kısmı için copyWith kullanırız. Sadece tek bir değer değiştirmke istiyoruz. Bu da true false değeri(fav için)
        int? id,
        String? baslik,
        String? aciklama,
        double? fiyat,
        String? resimUrl,
        Category? kategori, //veri tipi yukarda belli tekrar belirtmiyoruz
        int? stokAdedi,
        bool? favoriMi 
    }){
        return Urun(
        id:id ?? this.id, // ?? : ifnull (null ise varsayılanı al demek)
        baslik:baslik ?? this.baslik, 
        aciklama:aciklama ?? this.aciklama, 
        fiyat:fiyat ?? this.fiyat, 
        resimUrl:resimUrl ?? this.resimUrl, 
        kategori:kategori ?? this.kategori,  //?. : nesne boş bile olsa bana hata verme neyse o de geç
        stokAdedi:stokAdedi ?? this.stokAdedi, 
        favoriMi:favoriMi ?? this.favoriMi, 
        );
    }

    @override 
    String toString(){ // string değerin içinde herhangi bir başka veri varsa onu da stringe çeviriyoruz hatasız çıktı alıyoruz consolede
        return "Urun(id: $id, baslik: $baslik, fiyat: $fiyat, favoriMi: $favoriMi)"; 
    }
    
}