import 'package:flutter/material.dart';

class HataliveDogruRow extends StatelessWidget {
  const HataliDogruRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text("Row ve layout")),
        body:Padding(
          padding:const EdgeInsets.all(16.0),
          child:Column(
            crossAxisAlignment:CrossAxisAlignment.start, // start ile sütund old. için en üstten başladuı
            children:[
              const Text(
                'Hatalı YApı: A overflowed by *** pixels(sarı siyah şerit)',
                style:TextStyle(fontWeight:FontWeight.bold,color:Colors.red),
              ),
            const SizedBox(height:8), 


            Container(
              color: Colors.amber.shade100,
              child: Row(
                children:[
                  const Icon(Icons.warning, color:Colors.red),
                  const SizedBox(width:8),
                  const Text('Kısa metin hata vermrez ama uzarsa Render patlar'),
                ],
              ),
            ),

            const SizedBox(height:32),
            const Text('Doğru YApı: Flexible ve expanded ile sınırlandırılmış', 
            style:TextStyle(fontWeight:FonttWeight.bold,color:Colors.green),
            ),       
            
            ],
            
          ),

          Container( // container altı row oluşturduysan her kutuya kendi sizeını vermen laxzım
            padding:const EdgeInsets.all(12),
            decoration:BoxDecoration(
              color:Colors.green.shade50,
              borderRadius:BorderRadius.circular(8),
              border:Border.all(color:Colors.green),
              ),
              child:Row(
                children:[
                  const CircleAvatar(
                    backgroundColor:Colors.green,
                    child:Icon(Icons.check,color:Colors.white),
                  ),
                  const SizedBox(width:12),

                  Expanded(
                    child:Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children:const[
                        Text('Softito 4. Dönem Mobil Standartı',
                        style:TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height:4),
                        Text('Bu metin ne kadar uzun olursa olsun telefonun ekranının genişliğinde alt satıra geçer ve asla sarı siyah render,taşma hataso üretmez',
                        style: TextStyle(color:Colors.black87),
                        ),
                      ],
                    ),
                    ),
                ]
              )
          )
        ),
    );
    
  }

}