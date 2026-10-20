/// otoVia Kullanıcı Profil Modeli
///
/// Uygulamaya kayıtlı kullanıcının kimlik, iletişim, ehliyet sınıfı
/// ve hesap doğrulama bilgilerini temsil eder.
class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.surname,
    required this.phone,
    required this.email,
    this.driverLicenseClass = 'B',
    this.isVerified = true,
  });

  /// Kullanıcı benzersiz kimlik numarası (UUID / ID)
  final String id;

  /// Kullanıcının adı
  final String name;

  /// Kullanıcının soyadı
  final String surname;

  /// Telefon numarası (ör. 0532xxxxxxx)
  final String phone;

  /// E-posta adresi
  final String email;

  /// Sahip olunan ehliyet sınıfı (ör. 'B', 'A2', 'C', 'D1')
  final String driverLicenseClass;

  /// Kullanıcının kimlik ve ehliyet doğrulamasının onay durumu
  final bool isVerified;

  /// Ad ve soyadı birleştiren tam isim yardımcısı
  String get fullName => '$name $surname';

  /// Mevcut modelin belirli alanlarını güncelleyip yeni bir nesne kopyası oluşturan yardımcı metot
  UserModel copyWith({
    String? name,
    String? surname,
    String? phone,
    String? email,
    String? driverLicenseClass,
    bool? isVerified,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      driverLicenseClass: driverLicenseClass ?? this.driverLicenseClass,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
