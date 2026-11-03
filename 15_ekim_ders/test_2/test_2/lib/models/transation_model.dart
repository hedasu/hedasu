// -bu dosyada gelir ve gider işlemlerini (harcama, hakediş, para transferi) temsil eden TransactionItem veri modeli anlatılıyor.-
// IconData: Flutter'ın Material ikonlarını (Icons.laptop_mac, Icons.send_rounded vb.) bir veri tipi olarak değişkenlerde saklamamızı sağlayan sınıftır.
// bool (Boolean): Sadece iki değer (true veya false) alabilen mantıksal veri tipidir; burada işlemin gider mi (true) yoksa gelir mi (false) olduğunu ayırt eder.

import 'package:flutter/material.dart'; // IconData tipini kullanabilmek için material.dart kütüphanesi import edilmiştir.

class TransactionItem { // TransactionItem: İşlem geçmişindeki her bir satırı/kartı temsil eden veri modeli sınıfı.
  final String id; // id: İşlemin benzersiz kimlik numarası (Örn: 'tx_1' veya 'tx_17123456').
  final String title; // title: İşlemin ana başlığı veya karşı tarafın adı (Örn: 'Apple Store', 'Ahmet Yılmaz').
  final String category; // category: İşlemin kategorisi (Örn: 'Teknoloji', 'Kurumsal Gelir', 'Hızlı Transfer').
  final String date; // date: İşlem tarihi ve saati (Örn: 'bugün 14:20').
  final double amount; // amount: İşlemin TL cinsinden tutarı (Örn: 64500.00).
  final bool isExpense; // isExpense: true ise para çıkışı (Gider -> Kırmızı renk ve '-' işareti), false ise para girişi (Gelir -> Yeşil renk ve '+' işareti).
  final IconData icon; // icon: İşlem kartında gösterilecek ikon (Örn: Icons.laptop_mac).

  // const Yapıcı Metot (Constructor): Tüm alanlar final olduğu için const olarak tanımlanabilir; bellekte sabit (değişmez) nesneler oluşturur.
  const TransactionItem({
    required this.id, // required: Nesne oluşturulurken id parametresinin girilmesi zorunludur.
    required this.title, // this.title: Parametre olarak gelen başlığı sınıfın title özelliğine atar.
    required this.category, // required: Kategori bilgisi zorunludur.
    required this.date, // required: Tarih bilgisi zorunludur.
    required this.amount, // required: Tutar bilgisi zorunludur.
    required this.isExpense, // required: Gelir/Gider durumu (true/false) zorunludur.
    required this.icon, // required: İkon verisi zorunludur.
  });
}

// ÇALIŞMA MANTIĞI:
// Yeni bir işlem yapıldığında veya sabit liste tanımlandığında TransactionItem(...) çağrılır -> Tüm zorunlu (required) alanlar doldurulur -> Oluşan nesne List<TransactionItem> içine eklenir -> ListView.separated bu listedeki her nesneyi sırayla okuyarak ekranda işlem kartı (_buildTransactionCard / _buildHistoryCard) olarak gösterir.

// ASSET MODELİ : Kullanıcının sahip olduğu kripto varlıkların anlık durumunu (fiyat, 24s değişim, bakiye) tutar.
//  VS
// TRANSACTIONITEM MODELİ : Kullanıcının geçmişte yaptığı para giriş/çıkış hareketlerini (kimle, ne zaman, ne kadar, gelir mi gider mi) tutar.
