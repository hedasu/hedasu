import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/packing_list_controller.dart';

class AddItemDialog extends StatefulWidget {
  final PackingListController controller;
  final String? initialCategory;

  const AddItemDialog({
    super.key,
    required this.controller,
    this.initialCategory,
  });

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final _nameCtrl = TextEditingController();
  late String _selectedCat;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    final cats = widget.controller.availableCategories.value;
    _selectedCat = widget.initialCategory ?? (cats.isNotEmpty ? cats.first : 'Giyim');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final surfaceColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    final cats = widget.controller.availableCategories.value;

    return AlertDialog(
      backgroundColor: surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: borderColor),
      ),
      title: Text(
        'Yeni Eşya Ekle',
        style: GoogleFonts.manrope(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameCtrl,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Eşya Adı',
                hintText: 'Örn: Şarj Kablosu, Tişört, Pasaport...',
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Kategori',
              style: GoogleFonts.inter(fontSize: 12, color: textSecondary, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _selectedCat,
              dropdownColor: surfaceColor,
              decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
              items: cats.map((cat) {
                return DropdownMenuItem(
                  value: cat,
                  child: Text(cat, style: GoogleFonts.inter(fontSize: 13, color: textPrimary)),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedCat = val);
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Adet / Miktar:',
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimary),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline, size: 20, color: textSecondary),
                      onPressed: () {
                        if (_quantity > 1) setState(() => _quantity--);
                      },
                    ),
                    Text(
                      '$_quantity',
                      style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: textPrimary),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline, size: 20, color: primaryColor),
                      onPressed: () => setState(() => _quantity++),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Vazgeç', style: GoogleFonts.inter(color: textSecondary)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: isDark ? const Color(0xFF101C1B) : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            final name = _nameCtrl.text.trim();
            if (name.isNotEmpty) {
              widget.controller.addItem(
                name: name,
                category: _selectedCat,
                quantity: _quantity,
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Ekle'),
        ),
      ],
    );
  }
}
