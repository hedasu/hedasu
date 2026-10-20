import 'package:flutter/material.dart';
import '../controller/startup_controller.dart';

class StartupFormView extends StatefulWidget {
  final StartupController controller;

  const StartupFormView({super.key, required this.controller});

  @override
  State<StartupFormView> createState() => _StartupFormViewState();
}

class _StartupFormViewState extends State<StartupFormView> {
  late final TextEditingController _nameController;
  late final TextEditingController _sectorController;
  late final TextEditingController _descController;
  late final TextEditingController _stageController;

  @override
  void initState() {
    super.initState();
    final model = widget.controller.startup.value;
    _nameController = TextEditingController(text: model.name);
    _sectorController = TextEditingController(text: model.sector);
    _descController = TextEditingController(text: model.description);
    _stageController = TextEditingController(text: model.currentStage);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sectorController.dispose();
    _descController.dispose();
    _stageController.dispose();
    super.dispose();
  }

  void _onSave() {
    final current = widget.controller.startup.value;
    widget.controller.updateStartup(
      current.copyWith(
        name: _nameController.text.trim(),
        sector: _sectorController.text.trim(),
        description: _descController.text.trim(),
        currentStage: _stageController.text.trim(),
      ),
    );
    widget.controller.save().then((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Girişim bilgileri kaydedildi!')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Girişim Detayları')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FormFields(
                nameController: _nameController,
                sectorController: _sectorController,
                descController: _descController,
                stageController: _stageController,
              ),
              const SizedBox(height: 24),
              _SaveButton(controller: widget.controller, onSave: _onSave),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController sectorController;
  final TextEditingController descController;
  final TextEditingController stageController;

  const _FormFields({
    required this.nameController,
    required this.sectorController,
    required this.descController,
    required this.stageController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Girişim Fikrinin Adı'),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: sectorController,
          decoration: const InputDecoration(labelText: 'Sektör / Faaliyet Alanı'),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: stageController,
          decoration: const InputDecoration(labelText: 'Mevcut Gelişim Aşaması'),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: descController,
          maxLines: 4,
          decoration: const InputDecoration(labelText: 'İş Fikrinin Açıklaması ve Amacı'),
        ),
      ],
    );
  }
}

class _SaveButton extends StatelessWidget {
  final StartupController controller;
  final VoidCallback onSave;

  const _SaveButton({required this.controller, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: controller.isSaving,
      builder: (context, saving, _) {
        return SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: saving ? null : onSave,
            child: saving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Bilgileri Kaydet'),
          ),
        );
      },
    );
  }
}
