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

  final String id;
  final String name;
  final String surname;
  final String phone;
  final String email;
  final String driverLicenseClass;
  final bool isVerified;

  String get fullName => '$name $surname';

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
