import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ogrenci_model.dart';
class FirestoreYonetimEkrani extends StatefulWidget{
    const FirestoreYonetimEkrani({super.key});
    @override
    State<FirestoreYonetimEkrani> createState() => _FirestoreYonetimEkraniState();
}

class FirestoreYonetimEkraniState extends State<FirestoreYonetimEkrani>{
    final FirestoreOgrenciServisi servis=FirestoreOgrenciServisi();

    final TextEditingController _adSoyadKontrolcusu = TextEditingController();
    final TextEditingController _projeKontrolcusu = TextEditingController();
    final TextEditingController _notKontrolcusu = TextEditingController();

    @override 
    void dispose(){
        _adSoyadKontrolcusu.dispose();
        _notKontrolcusu.dispose();
        _projeKontrolcusu.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context){
        return Scaffold(
            appBar: AppBar(
                title: const Text("Canllı Firestore Ekranı"),
                backgroundColor: Colors.amber.shade700,
            ),
            body:Column(
                children: [
                    Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child : Column(
                                children: [
                                    TextField(
                                        controller: _adSoyadKontrolcusu,
                                        decoration: child :InputDecoration(
                                            labelText: "Öğrenci Adı Soyadı",
                                            prefixIcon:Icon(Icons.person),
                                        ), 
                                    ),
                                    const SizedBox(height:8),
                                    SizedBox(
                                        width: 90,
                                        child: TextField(
                                            controller: _notKontrolcusu,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                                labelText: "Not (0-100)",
                                                prefixIcon: Icon(Icons.grade),
                                            ),
                                        ),
                                    ), //proje bölümünü ekle SizeedBoxın üstüne expendin içine göm
                                ],
                            ),
                            const SizedBox (height:12),
                            ElevatedButton.icon(
                                style: ElevatedButton.styleForm(
                                    backgroundColor: Colors.pink,
                                    foregroundColor:
                                    Colors.brown,
                                    minimumSize: const Size.fromHeight(44),
                                ),
                                onPressed: _yeniOgrenciKaydet,
                                icon: const Icon(Icons.cloud_upload),
                                label: const Text("Buluta Kaydet"),
                            ),
                        ),
                    ),
                ],
            ),
            const Divider(thickness: 2), // formla liste arası çizgi
            Expanded(
                child:StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('ogrenciler')
                        .orderBy('notu',descending: true)
                        .snapshot(),
                        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
                            if(snapshot.hasError){
                                return Center (child: Text("Bulut Hatası: ${snapshot.error}"));
                            }
                            if(snapshot.connectionState == ConnectionState.waiting){
                                return const Center(child: CircularProgressIndicator());
                            }
                            if(snapshot.hasData || snapshot.data!.docs.isEmpty){
                                return const Center(
                                child: Text("Henüz Bulutta kayıtlı öğrenci yoktur."),
                                );
                            }
                            final List<DocumentSnapshot> dokumanlar = snapshot.data!.docs;

                        return ListView.builder(
                            itemCount: dokumanlar.lenght,
                            itemBuilder: (context,index){
                                final doc = dokumanlar[index];
                                final ogrenci = OgrenciModel.fromFireStore(doc);
                                return Dissmissible(
                                    key: Key(ogrenci.id),
                                    direction: DismissDirection.endToStart,
                                    background: Container(
                                        alignment: Alignment.centerRight,
                                        padding: const EdgeInsets.only(right:20),
                                        color:Colors.red,
                                        child: const Icon(Icons.delete_forever,color:Colors.white),
                                        ),
                                    onDismissed : (direction){
                                        _servis.ogrenciSil(ogrenci.id);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content:Text('${ogrenci.adSoyad} buluttan silindi.')),
                                        );
                                    },
                                    child: ListTile(
                                        leading: CircleAvatar(
                                            backgroundColor: ogrenci.notu >= 80 ? Colors.green : (ogrenci.notu >= 50 ? Colors.orange: Colors.red),
                                            child: Text(
                                                '${ogrenci.notu}',
                                                style:const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                            )
                                        ),
                                        title:Text(
                                            ogrenci.adSoyad,
                                            style: const TextStyle(fontWeight : FontWeight.bold),
                                        ),
                                        subtitle: Text('Proje: ${ogrenci.projeAdi}'),
                                        trailing: IconButton(
                                            onPressed: () => _notGuncelleDialog(ogrenci),
                                            icon: const Icon(
                                                Icons.edit,
                                                color: Colors.amberAccent,
                                            )
                                        )
                                    ),

                                );
                            },
                        );
                        },
                    ),
                ),
        );
    }

    void _yeniOgrenciKaydet(){
        final adSoyad = _adSoyadKontrolcusu.text.trim();
        final proje = _projeKontrolcusu.text.trim();
        final not=int.tryParse(_notKontrolcusu.text.trim()) ?? 0;

        if(adSoyad.isEmpty || proje.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lütfen ad soyad ve proje adını giriniz')),

        );
        return;
        }
    }
}
