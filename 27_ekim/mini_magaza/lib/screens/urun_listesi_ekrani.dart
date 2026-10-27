import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/urun.dart';
import '../services/i_urun_servisi.dart';
import '../services/mock_urun_servisi.dart';

class UrunListesiEkrani extends StatefulWidget {
    const UrunListesiEkrani({super.key});

    @override
    State<UrunListesiEkrani> createState() => _UrunListesiEkraniState(); // State:depo olarak görev yapıyor ve verileri saklıyor

}

class _UrunListesiEkraniState extends State<UrunListesiEkrani>{  
        final IUrunServisi _servis=MockUrunServisi();
        bool _yukleniyorMu=true;
        Category _seciliKategori=Category.hepsi;
        
        String _aramaKelimesi="";
        
        List<Urun> _gosterilenUrunler=[];
        
        @override
        void initState(){ //widget ilk kez oluşturulduğunda burası çalışır
            super.initState();
            _urunleriYukle();
        }
        
        Future<void> _urunleriYukle()async{
            
            setState((){
                _yukleniyorMu=true;
            });

            final urunler= await _servis.kategoriyeGoreGetir(_seciliKategori);
            
            if(mounted){
                setState((){
                    _gosterilenUrunler=urunler;
                    _yukleniyorMu=false;
                });
            }


        }

        @override
        Widget build(BuildContext context){
            return Scaffold(
                appBar: AppBar(
                    title: const Text("Mini Mağaza"),
                ),
                body: _yukleniyorMu ? const Center (child: CircularProgressIndicator()): 
                Center(child: Text('${_gosterilenUrunler.length} Adet ürün hazır.')),
            );
        }


        

}
