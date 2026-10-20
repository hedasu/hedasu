/// Kullanıcı Profil Detayları Modeli
class ProfileDetailsModel {
  final String fullName;
  final String email;
  final String title;
  final List<String> activeRoles;
  final int completenessPercent;
  final List<String> skills;
  final List<String> connectedMentors;
  final String activeProject;

  const ProfileDetailsModel({
    required this.fullName,
    required this.email,
    required this.title,
    required this.activeRoles,
    required this.completenessPercent,
    required this.skills,
    required this.connectedMentors,
    required this.activeProject,
  });

  factory ProfileDetailsModel.sample() {
    return const ProfileDetailsModel(
      fullName: 'Can Demir',
      email: 'can.demir@startpath.dev',
      title: 'Fintek Girişimcisi & Mobil Ürün Yöneticisi',
      activeRoles: ['Fikrim Var', 'Mentor Olmak İstiyorum'],
      completenessPercent: 90,
      skills: ['Flutter', 'Ürün Yönetimi', 'Fintek Regülasyonu', 'Yatırım Hazırlığı'],
      connectedMentors: ['Ayşe Yılmaz (Fintech)', 'Dr. Kerem Aksoy (Hukuk)'],
      activeProject: 'PayWise Fintek',
    );
  }
}
