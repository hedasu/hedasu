/// Girişimcilik Fikir ve Profil Modeli
class StartupModel {
  final String id;
  final String name;
  final String sector;
  final String fieldOfActivity;
  final String description;
  final String purposeAndGoals;
  final String targetAudience;
  final String currentStage; // Fikir, MVP, Erken Aşama, Büyüme
  final String teamStatus; // Bireysel, Mevcut Ekip, Ekip Arkadaşı Arıyor
  final List<String> neededSupports;

  const StartupModel({
    required this.id,
    required this.name,
    required this.sector,
    required this.fieldOfActivity,
    required this.description,
    required this.purposeAndGoals,
    required this.targetAudience,
    required this.currentStage,
    required this.teamStatus,
    required this.neededSupports,
  });

  StartupModel copyWith({
    String? id,
    String? name,
    String? sector,
    String? fieldOfActivity,
    String? description,
    String? purposeAndGoals,
    String? targetAudience,
    String? currentStage,
    String? teamStatus,
    List<String>? neededSupports,
  }) {
    return StartupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      sector: sector ?? this.sector,
      fieldOfActivity: fieldOfActivity ?? this.fieldOfActivity,
      description: description ?? this.description,
      purposeAndGoals: purposeAndGoals ?? this.purposeAndGoals,
      targetAudience: targetAudience ?? this.targetAudience,
      currentStage: currentStage ?? this.currentStage,
      teamStatus: teamStatus ?? this.teamStatus,
      neededSupports: neededSupports ?? this.neededSupports,
    );
  }

  factory StartupModel.sample() {
    return const StartupModel(
      id: 'st_1',
      name: 'PayWise Fintek',
      sector: 'Fintech',
      fieldOfActivity: 'Mikro KOBİ Ödeme Sistemleri',
      description:
          'KOBİ\'lerin e-ticaret siteleri ve fiziki mağazalarında tek tıkla tahsilat yapmalarını sağlayan yeni nesil ödeme altyapısı.',
      purposeAndGoals:
          'Balkanlar ve Orta Doğu pazarına açılarak 100.000 aktif KOBİ\'ye ulaşmak.',
      targetAudience: 'Küçük ve Orta Ölçekli İşletmeler, Freelancerlar',
      currentStage: 'MVP Aşaması',
      teamStatus: 'Ekip Arkadaşı Arıyor',
      neededSupports: ['Hukuki Danışmanlık', 'Yatırım Turu', 'Full-stack Geliştirici'],
    );
  }
}
