import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/storage_service.dart';
import '../controllers/shopping_controller.dart';
import '../models/shopping_item_model.dart';
import '../widgets/shopping_item_tile.dart';

class ShoppingView extends StatefulWidget {
  final StorageService storageService;

  const ShoppingView({super.key, required this.storageService});

  @override
  State<ShoppingView> createState() => _ShoppingViewState();
}

class _ShoppingViewState extends State<ShoppingView> {
  late final ShoppingController controller;
  final _itemCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = ShoppingController(storageService: widget.storageService);
  }

  @override
  void dispose() {
    controller.dispose();
    _itemCtrl.dispose();
    super.dispose();
  }

  void _showAddDialog() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final surfaceColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    showDialog(
      context: context,
      builder: (ctx) {
        String cat = 'Kişisel İhtiyaç';
        return AlertDialog(
          backgroundColor: surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: borderColor),
          ),
          title: Text(
            'Alışveriş Listesine Ekle',
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _itemCtrl,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Ürün Adı',
                  hintText: 'Örn: Seyahat Adaptörü, Güneş Kremi...',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Vazgeç', style: GoogleFonts.inter(color: textSecondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: isDark ? const Color(0xFF101C1B) : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                if (_itemCtrl.text.trim().isNotEmpty) {
                  await controller.addItem(title: _itemCtrl.text, category: cat);
                  _itemCtrl.clear();
                  if (context.mounted) Navigator.pop(ctx);
                }
              },
              child: const Text('Ekle'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seyahat Alışveriş Listem'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_rounded, color: primaryColor, size: 24),
            onPressed: _showAddDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: ValueListenableBuilder<List<ShoppingItemModel>>(
          valueListenable: controller.items,
          builder: (context, items, _) {
            if (items.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.shopping_bag_outlined, size: 48, color: textSecondary),
                      const SizedBox(height: 14),
                      Text(
                        'Alışveriş listeniz boş',
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Seyahatinizden önce satın almanız gereken eşyaları buraya ekleyebilirsiniz.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(fontSize: 13, color: textSecondary),
                      ),
                      const SizedBox(height: 18),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: isDark ? const Color(0xFF101C1B) : Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _showAddDialog,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('İlk Ürünü Ekle'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final pending = items.where((i) => !i.isPurchased).toList();
            final bought = items.where((i) => i.isPurchased).toList();

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              children: [
                if (pending.isNotEmpty) ...[
                  Text(
                    'Alınacaklar (${pending.length})',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...pending.map(
                    (it) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ShoppingItemTile(
                        item: it,
                        onToggle: () => controller.toggleItem(it.id),
                        onDelete: () => controller.deleteItem(it.id),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                if (bought.isNotEmpty) ...[
                  Text(
                    'Satın Alınanlar (${bought.length})',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...bought.map(
                    (it) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ShoppingItemTile(
                        item: it,
                        onToggle: () => controller.toggleItem(it.id),
                        onDelete: () => controller.deleteItem(it.id),
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
