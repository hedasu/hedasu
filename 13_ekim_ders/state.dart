import 'package:flutter/material.dart';

1. createState()


2. mounted == true. //ağaç başladı anlamına gelir


3. initState()


4. didChangeDependencies(). (widget değişimlerinde tetiklenir (Thema.of(context) bu adımda güvenli olarak çalıştırılır))


5. build(BuildContext context) (UI burda döndürür (ASLA İÇİNDE ASENKRON İŞLEM YAPILMAZ))

// build yapmak : apk çıkarmak

6. didUpdateWidget(oldWidget) (üst ebeveyn yeni bir parametre gönderdiğinde çalışır)


7. deactivite() (ağaçtan geçici olarak kopma)


8. dispose() (kalıcı olarak kapatma (controller.dispose Stream.cancel)burada yapılır)


9. mounted == false 


// KODU ÖĞREN
