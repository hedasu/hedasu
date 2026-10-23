import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class BadgeProgress extends StatelessWidget {
  final int unlockedCount;
  final int totalCount;
  final int totalCoins;
  final bool isDark;

  const BadgeProgress({
    super.key,
    required this.unlockedCount,
    required this.totalCount,
    required this.totalCoins,
    this.isDark = false,
  });

  void _showHierarchyInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark
          ? AppColors.badgeCardBackgroundDark
          : AppColors.badgeCardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _HierarchyInfoModal(isDark: isDark),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark
        ? AppColors.badgeCardBackgroundDark
        : AppColors.badgeCardBackground;
    final borderColor =
        isDark ? AppColors.badgeCardBorderDark : AppColors.badgeCardBorder;
    final primaryTextColor =
        isDark ? AppColors.badgeUnlockedTitleDark : AppColors.specialTitleText;
    final secondaryTextColor =
        isDark ? AppColors.darkTextSecondary : AppColors.specialDescText;
    final coinColor = isDark
        ? AppColors.badgeRewardTagTextDark
        : AppColors.badgeRewardTagText;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          // Sol: Kazanılan Rozet Sayacı
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark
                        ? AppColors.badgeUnlockedIconBgDark
                        : AppColors.badgeUnlockedIconBg,
                    border: Border.all(
                      color: isDark
                          ? AppColors.badgeUnlockedIconBorderDark
                          : AppColors.badgeUnlockedIconBorder,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.military_tech_rounded,
                    size: 20,
                    color: isDark
                        ? AppColors.badgeUnlockedIconColorDark
                        : AppColors.badgeUnlockedIconColor,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'KAZANILAN',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: secondaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      '$unlockedCount / $totalCount',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: primaryTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Dikey zarif ayırıcı
          Container(
            height: 28,
            width: 1,
            color: borderColor,
          ),
          const SizedBox(width: 14),

          // Sağ: Rozet Bakiyesi ve Bilgi Butonu
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'BAKİYE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                      color: secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🪙', style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 4),
                      Text(
                        '$totalCoins',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: coinColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () => _showHierarchyInfo(context),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: secondaryTextColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HierarchyInfoModal extends StatelessWidget {
  final bool isDark;

  const _HierarchyInfoModal({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final titleColor =
        isDark ? AppColors.badgeUnlockedTitleDark : AppColors.specialTitleText;
    final bodyColor =
        isDark ? AppColors.darkTextSecondary : AppColors.specialDescText;

    final tiers = [
      ('🥇', 'Yıllık Rozetler', 'En prestijli ve en yüksek coin ödüllü rozetler (365 Gün).', AppColors.badgeYearly),
      ('🥈', 'Aylık Rozetler', '30 günlük istikrarlı alışkanlık tamamlama ödülleri.', AppColors.badgeMonthly),
      ('🥉', 'Haftalık Rozetler', '7 günlük periyot serisi tamamlama ödülleri.', AppColors.badgeWeekly),
      ('🏅', 'Günlük Rozetler', 'İlk gün ve başlangıç başarı rozetleri.', AppColors.badgeDaily),
      ('🌟', 'Özel & Çoklu Rozetler', '21 Gün kuralı ve birden fazla alışkanlık hedefleri.', AppColors.badgeSpecial),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBorder : AppColors.badgeCardBorder,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  size: 20,
                  color: isDark ? AppColors.accentGold : AppColors.badgeUnlockedIconBorder,
                ),
                const SizedBox(width: 8),
                Text(
                  'Rozet Değer Sıralaması',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: titleColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Rozetlerin zorluk ve değer hiyerarşisi aşağıdan yukarıya artar:',
              style: TextStyle(fontSize: 13, color: bodyColor),
            ),
            const SizedBox(height: 14),
            ...tiers.map((t) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.$1, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: 13, color: bodyColor),
                            children: [
                              TextSpan(
                                text: '${t.$2}: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: titleColor,
                                ),
                              ),
                              TextSpan(text: t.$3),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: isDark
                      ? AppColors.darkSecondary
                      : AppColors.badgeUnlockedTitle,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Anladım'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
