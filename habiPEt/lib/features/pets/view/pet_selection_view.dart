import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_scope.dart';
import '../../../core/extensions/context_extensions.dart';
import '../models/pet_model.dart';

class PetSelectionView extends StatefulWidget {
  const PetSelectionView({super.key});

  @override
  State<PetSelectionView> createState() => _PetSelectionViewState();
}

class _PetSelectionViewState extends State<PetSelectionView> {
  late PetType _selectedType;
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentPet = AppScope.of(context).petController.pet;
    _selectedType = currentPet.type;
    if (_nameController.text.isEmpty) {
      _nameController.text = currentPet.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onSelectType(PetType type) {
    setState(() {
      _selectedType = type;
      _nameController.text = type.defaultName;
    });
  }

  void _saveChanges() {
    final petCtrl = AppScope.of(context).petController;
    petCtrl.changePetType(_selectedType);
    petCtrl.renamePet(_nameController.text);
    context.showAppSnackBar('Evcil hayvanın güncellendi! Tüm gelişimin aktarıldı. ✨');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evcil Hayvan Seç'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const _ProgressTransferNotice(),
                  const SizedBox(height: 20),
                  _PetNameInput(controller: _nameController),
                  const SizedBox(height: 24),
                  _PetGridSection(
                    selectedType: _selectedType,
                    onSelect: _onSelectType,
                  ),
                ],
              ),
            ),
            _BottomSaveBar(onSave: _saveChanges),
          ],
        ),
      ),
    );
  }
}

class _ProgressTransferNotice extends StatelessWidget {
  const _ProgressTransferNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkMint.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkMint.withValues(alpha: 0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.auto_awesome_rounded, color: AppColors.darkMint, size: 28),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Gelişim Koruması: Evcil hayvanını istediğin an değiştirebilirsin. Mevcut seviyen, yaşın ve tüm kazanımların anında yeni dostuna aktarılır!',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PetNameInput extends StatelessWidget {
  final TextEditingController controller;

  const _PetNameInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dostunun İsmi',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Bir isim ver...',
            prefixIcon: Icon(Icons.edit_rounded),
          ),
        ),
      ],
    );
  }
}

class _PetGridSection extends StatelessWidget {
  final PetType selectedType;
  final ValueChanged<PetType> onSelect;

  const _PetGridSection({
    required this.selectedType,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: PetType.values.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (context, index) {
        final type = PetType.values[index];
        final isSelected = type == selectedType;
        return _PetChoiceCard(
          type: type,
          isSelected: isSelected,
          onTap: () => onSelect(type),
        );
      },
    );
  }
}

class _PetChoiceCard extends StatelessWidget {
  final PetType type;
  final bool isSelected;
  final VoidCallback onTap;

  const _PetChoiceCard({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.darkMint.withValues(alpha: 0.15)
              : Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.darkMint : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(type.emoji, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 8),
            Text(
              type.displayName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? AppColors.darkMint : null,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              type.description,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomSaveBar extends StatelessWidget {
  final VoidCallback onSave;

  const _BottomSaveBar({required this.onSave});

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
          child: const Text('Seçimi Onayla & Kaydet'),
        ),
      ),
    );
  }
}
