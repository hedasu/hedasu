import 'package:flutter/material.dart';
import '../../auth/controller/auth_controller.dart';
import '../../../core/extensions/context_extensions.dart';

/// Profil Bilgilerini Düzenleme Modal Penceresi (EditProfileDialog)
///
/// Kullanıcının ad, soyad, telefon numarası ve ehliyet sınıfı (A, B, C, D1)
/// bilgilerini güncellemesini sağlayan etkileşimli bir [AlertDialog] penceresidir.
class EditProfileDialog extends StatefulWidget {
  const EditProfileDialog({super.key});

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late TextEditingController _nameCtrl;
  late TextEditingController _surnameCtrl;
  late TextEditingController _phoneCtrl;
  late String _licenseClass;

  @override
  void initState() {
    super.initState();
    // Mevcut kullanıcı verileriyle kontrolcüleri doldur
    final user = authController.currentUser;
    _nameCtrl = TextEditingController(text: user?.name ?? '');
    _surnameCtrl = TextEditingController(text: user?.surname ?? '');
    _phoneCtrl = TextEditingController(text: user?.phone ?? '');
    _licenseClass = user?.driverLicenseClass ?? 'B';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _surnameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Bilgileri Düzenle'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ad giriş alanı
            TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Ad')),
            const SizedBox(height: 10),
            // Soyad giriş alanı
            TextField(controller: _surnameCtrl, decoration: const InputDecoration(labelText: 'Soyad')),
            const SizedBox(height: 10),
            // Telefon numarası giriş alanı
            TextField(controller: _phoneCtrl, decoration: const InputDecoration(labelText: 'Telefon')),
            const SizedBox(height: 10),
            // Ehliyet sınıfı seçici açılır kutusu (Dropdown)
            DropdownButtonFormField<String>(
              initialValue: _licenseClass,
              decoration: const InputDecoration(labelText: 'Ehliyet Sınıfı'),
              items: const [
                DropdownMenuItem(value: 'A', child: Text('A Sınıfı (Motosiklet & Otomobil)')),
                DropdownMenuItem(value: 'B', child: Text('B Sınıfı (Otomobil & SUV)')),
                DropdownMenuItem(value: 'C', child: Text('C Sınıfı (Ağır Ticari)')),
                DropdownMenuItem(value: 'D1', child: Text('D1 Sınıfı (Minibüs & Geniş Grup)')),
              ],
              onChanged: (val) => setState(() => _licenseClass = val!),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Vazgeç')),
        FilledButton(onPressed: _save, child: const Text('Kaydet')),
      ],
    );
  }

  /// Güncellenen bilgileri AuthController'a kaydeden fonksiyon
  Future<void> _save() async {
    await authController.updateProfile(
      name: _nameCtrl.text.trim(),
      surname: _surnameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      licenseClass: _licenseClass,
    );
    if (!mounted) return;
    Navigator.pop(context);
    context.showAppSnackBar('Profil bilgileriniz güncellendi.');
  }
}
