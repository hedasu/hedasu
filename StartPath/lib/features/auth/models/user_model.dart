/// StartPath Kullanıcı Modeli (Immutable)
class UserModel {
  final String id;
  final String fullName;
  final String email;
  final List<String> roles; // ['Fikrim Var', 'Fikrim Yok', 'Mentor Olmak İstiyorum']
  final int profileCompleteness;
  final bool hasCompletedPersonalityTest;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.roles,
    required this.profileCompleteness,
    required this.hasCompletedPersonalityTest,
  });

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    List<String>? roles,
    int? profileCompleteness,
    bool? hasCompletedPersonalityTest,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      roles: roles ?? this.roles,
      profileCompleteness: profileCompleteness ?? this.profileCompleteness,
      hasCompletedPersonalityTest:
          hasCompletedPersonalityTest ?? this.hasCompletedPersonalityTest,
    );
  }

  factory UserModel.initialDemo() {
    return const UserModel(
      id: 'usr_1',
      fullName: 'Can Demir',
      email: 'can.demir@startpath.dev',
      roles: ['Fikrim Var', 'Mentor Olmak İstiyorum'],
      profileCompleteness: 85,
      hasCompletedPersonalityTest: true,
    );
  }
}
