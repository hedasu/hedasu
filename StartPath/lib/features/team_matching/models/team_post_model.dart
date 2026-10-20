/// Ekip Arayan Girişim İlan Modeli
class TeamPostModel {
  final String id;
  final String startupName;
  final String roleNeeded;
  final String sector;
  final int compatibilityScore; // Uyumluluk yüzdesi (ör. %94)
  final List<String> requiredSkills;
  final String workType; // Uzaktan, Hibrit, Ofis
  final String description;

  const TeamPostModel({
    required this.id,
    required this.startupName,
    required this.roleNeeded,
    required this.sector,
    required this.compatibilityScore,
    required this.requiredSkills,
    required this.workType,
    required this.description,
  });

  static List<TeamPostModel> get samples => const [
        TeamPostModel(
          id: 'tp_1',
          startupName: 'HealthPulse AI',
          roleNeeded: 'Kurucu Ortak & Mobil Geliştirici',
          sector: 'HealthTech',
          compatibilityScore: 94,
          requiredSkills: ['Flutter', 'REST API', 'Girişimci Ruhu'],
          workType: 'Uzaktan',
          description:
              'Kronik hastaların biyometrik verilerini izleyen yapay zeka destekli platformumuz için çekirdek ekibe mobil ortak arıyoruz.',
        ),
        TeamPostModel(
          id: 'tp_2',
          startupName: 'EcoTrack Carbon',
          roleNeeded: 'Büyüme & Pazarlama Lideri',
          sector: 'CleanTech',
          compatibilityScore: 88,
          requiredSkills: ['B2B Satış', 'Büyüme Stratejisi', 'LinkedIn'],
          workType: 'Hibrit',
          description:
              'Şirketlerin karbon ayak izini hesaplayan SaaS ürünümüzü Avrupa pazarına sunacak dinamik büyüme lideri arıyoruz.',
        ),
        TeamPostModel(
          id: 'tp_3',
          startupName: 'RoboLogist',
          roleNeeded: 'Backend & Bulut Mimarı',
          sector: 'Lojistik / Derin Teknoloji',
          compatibilityScore: 82,
          requiredSkills: ['Go', 'PostgreSQL', 'Docker'],
          workType: 'Uzaktan',
          description:
              'Depo otomasyonlarında rota optimizasyonu sağlayan algoritmalarımız için yüksek ölçeklenebilir backend mimarı arıyoruz.',
        ),
      ];
}
