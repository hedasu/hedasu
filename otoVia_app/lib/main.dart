import 'package:flutter/material.dart';
import 'core/services/storage_service.dart';
import 'app/app.dart';

/// otoVia Araç Kiralama Uygulaması - Giriş Noktası
/// 
/// Uygulama başlatılmadan önce gerekli servislerin (ör. SharedPreferences tabanlı StorageService)
/// başlatılmasını sağlar ve kök bileşen olan [OtoViaApp] widget'ını çalıştırır.
Future<void> main() async {
  // Flutter widget ağacının ve asenkron bağlayıcıların hazır olduğundan emin oluyoruz.
  WidgetsFlutterBinding.ensureInitialized();

  // Kalıcı yerel depolama servisini (SharedPreferences) ilklendiriyoruz (tema, kullanıcı verisi vb.).
  await StorageService.init();

  // Uygulama kök widget'ını ayağa kaldırıyoruz.
  runApp(const OtoViaApp());
}
