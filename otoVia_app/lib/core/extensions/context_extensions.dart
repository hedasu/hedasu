import 'package:flutter/material.dart';

/// [BuildContext] üzerine eklenen yardımcı genişletmeler (extensions).
///
/// Tema, renk paleti, ekran boyutları ve bildirim (SnackBar) gösterimi gibi
/// sık kullanılan işlemlere bağlam (context) üzerinden doğrudan ve pratik erişim sağlar.
extension ContextExtensions on BuildContext {
  /// Mevcut temanın [ThemeData] nesnesi
  ThemeData get theme => Theme.of(this);

  /// Mevcut temanın renk şeması ([ColorScheme])
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Mevcut temanın tipografi stilleri ([TextTheme])
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Temanın karanlık modda olup olmadığını bildirir
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Ekranın toplam piksel genişliği
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Ekranın toplam piksel yüksekliği
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// Uygulama tasarımına uygun şık, kayan (floating) bir SnackBar gösterir.
  ///
  /// [message] Gösterilecek metin mesajı.
  /// [isError] Hata mesajı ise hata rengi arka plan uygulanır.
  /// [actionLabel] ve [onAction] isteğe bağlı geri alma (Undo) veya işlem butonu tanımlar.
  void showAppSnackBar(
    String message, {
    bool isError = false,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    // Önceki açık bildirim varsa kapatıyoruz
    ScaffoldMessenger.of(this).hideCurrentSnackBar();

    // Yeni SnackBar mesajını gösteriyoruz
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? colorScheme.error
            : (isDarkMode ? const Color(0xFF2E2E2E) : const Color(0xFF1C1C1C)),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: (actionLabel != null && onAction != null)
            ? SnackBarAction(
                label: actionLabel,
                textColor: const Color(0xFFC0B09A),
                onPressed: onAction,
              )
            : null,
      ),
    );
  }
}
