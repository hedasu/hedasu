/// Destek ve Hibe Fırsat Modeli
class OpportunityModel {
  final String id;
  final String organization; // TÜBİTAK, KOSGEB, Girişim Vadisi vb.
  final String title;
  final String supportType; // Hibe, Hızlandırma, Yarışma, Kredi
  final String grantAmount;
  final String deadline;
  final String eligibilityCriteria;
  final String sector;

  const OpportunityModel({
    required this.id,
    required this.organization,
    required this.title,
    required this.supportType,
    required this.grantAmount,
    required this.deadline,
    required this.eligibilityCriteria,
    required this.sector,
  });

  static List<OpportunityModel> get samples => const [
        OpportunityModel(
          id: 'opp_1',
          organization: 'TÜBİTAK 1512',
          title: 'BİGG Bireysel Genç Girişim Programı',
          supportType: 'Geri Ödemesiz Hibe',
          grantAmount: '900.000 ₺',
          deadline: '15 Kasım 2026',
          eligibilityCriteria: 'Lisans/yüksek lisans mezunları, teknoloji tabanlı fikirler',
          sector: 'Teknoloji / Ar-Ge',
        ),
        OpportunityModel(
          id: 'opp_2',
          organization: 'KOSGEB',
          title: 'İleri Girişimci Destek Programı',
          supportType: 'Makine & Teçhizat Hilesi',
          grantAmount: '375.000 ₺',
          deadline: 'Sürekli Açık',
          eligibilityCriteria: 'İmalat ve yüksek teknoloji faaliyet alanında yeni kurulan şirketler',
          sector: 'İmalat / Yazılım',
        ),
        OpportunityModel(
          id: 'opp_3',
          organization: 'StartPath Acceleration',
          title: 'Global Scale Hızlandırma Kampı 2026',
          supportType: 'Hızlandırma & Mentorluk',
          grantAmount: '50.000 \$ Yatırım',
          deadline: '30 Aralık 2026',
          eligibilityCriteria: 'İlk faturasını kesmiş veya MVP aşamasında olan SaaS girişimleri',
          sector: 'Fintech / SaaS',
        ),
      ];
}
