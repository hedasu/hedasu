import 'package:flutter/material.dart';

/// Dünce uygulaması için Vintage Scrapbook renk paleti.
/// Aydınlık tema: Nostaljik kâğıt, krem, bej, pastel kahve, pudra tonları.
/// Koyu tema: Eski antika kitap, antrasit, sepya, eskitme deri, soluk altın tonları.
class AppColors {
  AppColors._();

  // --- Aydınlık Tema Renkleri (Nostaljik Defter & Kâğıt) ---
  static const Color lightBg = Color(0xFFF9F6EE); // Vintage krem / parşömen
  static const Color lightPaper = Color(0xFFFFFDF8); // Temiz kâğıt yüzeyi
  static const Color lightCard = Color(0xFFF3ECE0); // Hafif eskitme karton
  static const Color lightBorder = Color(0xFFE2D6C3); // İnce sepya çerçeve
  static const Color lightTextPrimary = Color(0xFF3E2E20); // Koyu kahve mürekkep
  static const Color lightTextSecondary = Color(0xFF7A6855); // Soluk sepya yazı
  static const Color lightAccent = Color(0xFF8B5A2B); // Sıcak kehribar / deri
  static const Color lightGold = Color(0xFFC59B27); // Soluk altın / pirinç
  static const Color lightTape = Color(0xDDE8D4B0); // Yarı saydam washi tape
  static const Color lightLine = Color(0x33A68B6D); // Defter çizgisi

  // --- Koyu Tema Renkleri (Antika Kitap & Sepya Gece) ---
  static const Color darkBg = Color(0xFF181412); // Gece kahvesi / antrasit
  static const Color darkPaper = Color(0xFF26201D); // Koyu parşömen
  static const Color darkCard = Color(0xFF332B27); // Antika deri cilt
  static const Color darkBorder = Color(0xFF5A4C43); // Eskitme metal / belirgin sepya
  static const Color darkTextPrimary = Color(0xFFFAF7F2); // Parlak fildişi / belirgin net yazı
  static const Color darkTextSecondary = Color(0xFFDACCC0); // Açık küllü sepya / rahat okunan alt metin
  static const Color darkAccent = Color(0xFFE8B684); // Parlak bal / kehribar ışıltısı
  static const Color darkGold = Color(0xFFF5C978); // Parlak antika altın
  static const Color darkTape = Color(0xBB634F42); // Belirgin koyu washi tape
  static const Color darkLine = Color(0x446B5748); // Koyu defter çizgisi

  // --- Scrapbook Özel Efekt & Vurgu Renkleri ---
  static const Color polaroidBorder = Color(0xFFFDFBF7);
  static const Color stampRed = Color(0xFFA93226); // Nostaljik kırmızı mühür
  static const Color sageGreen = Color(0xFF7D8C71); // Adaçayı yeşili washi
  static const Color dustyRose = Color(0xFFBC8A85); // Pudra pembe washi
  static const Color vintageBlue = Color(0xFF6B7F8C); // Soluk mavi washi
}
