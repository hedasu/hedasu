import 'package:flutter/material.dart';

/// Durum ve Kategori Rozeti (Status Badge / Tag) Bileşeni
///
/// Rezervasyon durumları (Aktif, Tamamlandı, İptal), araç kategorileri
/// ve ehliyet sınıfı gereksinimleri gibi küçük bilgi etiketlerini zarifçe gösterir.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
  });

  /// Rozet üzerinde görüntülenecek metin
  final String text;

  /// Rozet arka plan rengi
  final Color backgroundColor;

  /// Metin ve opsiyonel ikon rengi
  final Color textColor;

  /// Metnin solunda yer alacak opsiyonel mini ikon
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
