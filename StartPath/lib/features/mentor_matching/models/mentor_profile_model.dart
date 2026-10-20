/// Mentor Profili Modeli
class MentorProfileModel {
  final String id;
  final String fullName;
  final String title;
  final String sector;
  final double rating;
  final bool isVerified;
  final List<String> expertise;
  final String about;

  const MentorProfileModel({
    required this.id,
    required this.fullName,
    required this.title,
    required this.sector,
    required this.rating,
    required this.isVerified,
    required this.expertise,
    required this.about,
  });

  static List<MentorProfileModel> get samples => const [
        MentorProfileModel(
          id: 'm_1',
          fullName: 'Ayşe Yılmaz',
          title: 'Seri Girişimci & Fintek Danışmanı',
          sector: 'Fintech',
          rating: 4.95,
          isVerified: true,
          expertise: ['Fintech', 'Yatırım Turu', 'Büyüme'],
          about:
              '2 başarılı exit yapmış seri girişimci. Erken aşama B2B ve fintek şirketlerine ürün-pazar uyumu danışmanlığı veriyor.',
        ),
        MentorProfileModel(
          id: 'm_2',
          fullName: 'Dr. Kerem Aksoy',
          title: 'Hukuk Müşaviri & Patent Danışmanı',
          sector: 'Hukuk',
          rating: 4.88,
          isVerified: true,
          expertise: ['Şirketler Hukuku', 'Marka Tescili', 'Hissedarlık'],
          about:
              'Teknoloji girişimlerine şirket kuruluşu, yurt dışı açılımları ve yatırım sözleşmeleri konularında 12 yıllık deneyim.',
        ),
        MentorProfileModel(
          id: 'm_3',
          fullName: 'Selin Erdem',
          title: 'Ürün Lideri & Büyüme Koçu',
          sector: 'SaaS',
          rating: 4.92,
          isVerified: true,
          expertise: ['SaaS Metrikleri', 'Kullanıcı Deneyimi', 'GTM'],
          about:
              'Global SaaS platformlarında Product Director olarak görev aldı. Girişimcilere metrik takibi ve GTM stratejisi sunuyor.',
        ),
      ];
}
