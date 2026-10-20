import 'package:flutter/material.dart';

/// Kimlik Doğrulama Metin Giriş Alanı (AuthTextField)
///
/// Giriş yapma ve kayıt olma formlarında kullanılan etiketli, ikonlu
/// ve doğrulamalı (validation) standart form girdi bileşenidir.
class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.validator,
  });

  /// Metin kontrolcüsü
  final TextEditingController controller;

  /// Alanın üstünde yer alan etiket başlığı
  final String label;

  /// Giriş yapılmadığında gösterilecek ipucu metni
  final String hintText;

  /// Giriş alanının solunda gösterilecek ön ikon
  final IconData icon;

  /// Sanal klavye türü (ör. e-posta, telefon, sayısal)
  final TextInputType keyboardType;

  /// Şifre alanı olup olmadığını belirler (karakterleri maskeler)
  final bool isPassword;

  /// Form doğrulama fonksiyonu
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(context),
        const SizedBox(height: 6),
        _buildTextFormField(context),
      ],
    );
  }

  /// Alan etiketini inşa eden metot
  Widget _buildLabel(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  /// Metin giriş kutusunu (TextFormField) inşa eden metot
  Widget _buildTextFormField(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(
        fontSize: 15,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, size: 20),
      ),
    );
  }
}
