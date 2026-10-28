import 'package:flutter/material.dart';

import '../models/urun.dart';
import 'stok_rozeti.dart';

class UrunKarti extends StatelessWidget {
  // Stateless:sabit Stateful:yaşam döngüsü (değişken)

  final Urun urun;
  final VoidCallback?
  onFavoriTiklandi; // VoidCallback:fonksiyon döndürür, ?opsiyonel
  final VoidCallback? onDetayTiklandi;

  const UrunKarti({
    super.key,
    required this.urun,
    required this.onFavoriTiklandi,
    required this.onDetayTiklandi,
  });

  //width değerlerinde % veya px belirtmek zorunlu(düz cssde geçerli)

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        //dokunma hissi verir, geri bildirim sağlar
        borderRadius: BorderRadius.circular(12),
        onTap: onDetayTiklandi,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start, //start : sol üst köşeden başla (paddingden içeride kalan alan) end:sağ üst köşe , ending en son verilirse : sağ alt köşe
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  urun.resimUrl,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover, //resmi sıkıştır oran bozmadan
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      width: 90,
                      height: 90,
                      color: Colors.grey.shade100,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    //herkes aynı anda istek gönderdiği için url gelmesi sıkıntıya uğradı bu sebeple ekrana hata olarak geldi.foto basılsın diye errorBuilder yapıyoruz.
                    return Container(
                      width: 90,
                      height: 90,
                      color: Colors.grey.shade200,
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: Colors.grey.shade400,
                        size: 32,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                //Expanded:Resim boyutu büyürse kutuyu da o kadar büyütür,esneklik katar
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // spaceBetween : aralarındaki boşluğu eşitler
                      children: [
                        Text(
                          '${urun.kategori.ikon} ${urun.kategori.baslik}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        StokRozeti(stok: urun.stokAdedi),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      urun.baslik,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),

                    Text(
                      urun.aciklama,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      '${urun.fiyat.toStringAsFixed(2)} ₺',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  urun.favoriMi ? Icons.favorite : Icons.favorite_border,
                  color: urun.favoriMi ? Colors.red : Colors.grey,
                ),
                onPressed: onFavoriTiklandi,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
