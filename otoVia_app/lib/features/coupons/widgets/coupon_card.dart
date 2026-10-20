import 'package:flutter/material.dart';
import '../models/coupon_model.dart';
import '../../../core/extensions/context_extensions.dart';

class CouponCard extends StatelessWidget {
  const CouponCard({super.key, required this.coupon});

  final CouponModel coupon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isValid = coupon.isValid;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildDiscountBadge(context, isValid),
            const SizedBox(width: 14),
            Expanded(child: _buildInfoColumn(context, theme, isValid)),
            const SizedBox(width: 8),
            _buildAction(context, isValid),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscountBadge(BuildContext context, bool isValid) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: isValid ? const Color(0xFFC0B09A).withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          '%${coupon.discountPercent}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: isValid ? const Color(0xFFC0B09A) : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(BuildContext context, ThemeData theme, bool isValid) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          coupon.code,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
            color: isValid ? theme.colorScheme.onSurface : Colors.grey,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          coupon.title,
          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          'Geçerlilik: ${coupon.expiryDate.day}.${coupon.expiryDate.month}.${coupon.expiryDate.year}',
          style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7)),
        ),
      ],
    );
  }

  Widget _buildAction(BuildContext context, bool isValid) {
    return FilledButton.tonal(
      onPressed: isValid
          ? () {
              context.showAppSnackBar('${coupon.code} kupon kodu kopyalandı! Rezervasyon özetinde kullanabilirsiniz.');
            }
          : null,
      child: Text(coupon.isUsed ? 'Kullanıldı' : (coupon.isExpired ? 'Süresi Doldu' : 'Kullan')),
    );
  }
}
