import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_scope.dart';
import '../../../core/extensions/context_extensions.dart';
import '../widgets/habit_color_picker.dart';

class AddHabitView extends StatefulWidget {
  const AddHabitView({super.key});

  @override
  State<AddHabitView> createState() => _AddHabitViewState();
}

class _AddHabitViewState extends State<AddHabitView> {
  final _titleController = TextEditingController();
  final _targetController = TextEditingController();
  String _selectedCategory = 'Sağlık';
  IconData _selectedIcon = Icons.favorite_rounded;
  Color _selectedColor = AppColors.habitColors[0];

  static const List<String> _categories = [
    'Sağlık',
    'Fitness',
    'Ruh & Beden',
    'Üretkenlik',
    'Kişisel Gelişim',
    'Finans',
  ];

  static const List<IconData> _availableIcons = [
    Icons.favorite_rounded,
    Icons.fitness_center_rounded,
    Icons.water_drop_rounded,
    Icons.menu_book_rounded,
    Icons.bedtime_rounded,
    Icons.directions_run_rounded,
    Icons.self_improvement_rounded,
    Icons.savings_rounded,
    Icons.palette_rounded,
    Icons.laptop_chromebook_rounded,
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  void _saveHabit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      context.showAppSnackBar('Lütfen bir alışkanlık adı girin.', isError: true);
      return;
    }

    final habitCtrl = AppScope.of(context).habitController;
    final badgeCtrl = AppScope.of(context).badgeController;

    habitCtrl.addHabit(
      title: title,
      target: _targetController.text.trim().isEmpty
          ? 'Her gün düzenli tekrar'
          : _targetController.text.trim(),
      category: _selectedCategory,
      icon: _selectedIcon,
      color: _selectedColor,
    );

    // Sync badges (e.g. 2nd, 3rd, 5th habit special badges)
    badgeCtrl.syncProgressWithHabits(
      maxStreak: habitCtrl.maxStreak,
      habitCount: habitCtrl.habitCount,
    );

    context.showAppSnackBar('Yeni alışkanlığın eklendi! ✨');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Alışkanlık')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _HabitFormInputs(
                    titleCtrl: _titleController,
                    targetCtrl: _targetController,
                  ),
                  const SizedBox(height: 20),
                  _CategorySelector(
                    categories: _categories,
                    selectedCategory: _selectedCategory,
                    onSelect: (c) => setState(() => _selectedCategory = c),
                  ),
                  const SizedBox(height: 20),
                  _IconSelectorGrid(
                    icons: _availableIcons,
                    selectedIcon: _selectedIcon,
                    selectedColor: _selectedColor,
                    onSelect: (ic) => setState(() => _selectedIcon = ic),
                  ),
                  const SizedBox(height: 24),
                  HabitColorPicker(
                    selectedColor: _selectedColor,
                    onColorChanged: (c) => setState(() => _selectedColor = c),
                  ),
                ],
              ),
            ),
            _SaveHabitButton(onSave: _saveHabit),
          ],
        ),
      ),
    );
  }
}

class _HabitFormInputs extends StatelessWidget {
  final TextEditingController titleCtrl;
  final TextEditingController targetCtrl;

  const _HabitFormInputs({required this.titleCtrl, required this.targetCtrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Alışkanlık Adı', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        TextField(
          controller: titleCtrl,
          decoration: const InputDecoration(
            hintText: 'Örn: Yürüyüş Yapmak, Kod Yazmak...',
            prefixIcon: Icon(Icons.edit_note_rounded),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Günlük Hedef', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        TextField(
          controller: targetCtrl,
          decoration: const InputDecoration(
            hintText: 'Örn: Günde 10.000 adım veya 30 dk',
            prefixIcon: Icon(Icons.flag_outlined),
          ),
        ),
      ],
    );
  }
}

class _CategorySelector extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelect;

  const _CategorySelector({
    required this.categories,
    required this.selectedCategory,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Kategori', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((cat) {
            final isSelected = cat == selectedCategory;
            return ChoiceChip(
              label: Text(cat),
              selected: isSelected,
              onSelected: (_) => onSelect(cat),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _IconSelectorGrid extends StatelessWidget {
  final List<IconData> icons;
  final IconData selectedIcon;
  final Color selectedColor;
  final ValueChanged<IconData> onSelect;

  const _IconSelectorGrid({
    required this.icons,
    required this.selectedIcon,
    required this.selectedColor,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Simge Seç', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        SizedBox(
          height: 52,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: icons.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final icon = icons[index];
              final isSelected = icon == selectedIcon;
              return InkWell(
                onTap: () => onSelect(icon),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? selectedColor.withValues(alpha: 0.2)
                        : Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? selectedColor : Theme.of(context).dividerColor,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? selectedColor : null,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SaveHabitButton extends StatelessWidget {
  final VoidCallback onSave;

  const _SaveHabitButton({required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: onSave,
          child: const Text('Alışkanlığı Kaydet & Başla'),
        ),
      ),
    );
  }
}
