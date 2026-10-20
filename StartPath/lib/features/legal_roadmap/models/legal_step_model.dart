/// Hukuki Süreç Adım Modeli
class LegalStepModel {
  final String id;
  final int stepOrder;
  final String title;
  final String category; // Şirket Türü, Kuruluş, Vergi, Fikri Mülkiyet
  final String summary;
  final List<String> requiredDocuments;
  final bool isCompleted;

  const LegalStepModel({
    required this.id,
    required this.stepOrder,
    required this.title,
    required this.category,
    required this.summary,
    required this.requiredDocuments,
    required this.isCompleted,
  });

  LegalStepModel copyWith({bool? isCompleted}) {
    return LegalStepModel(
      id: id,
      stepOrder: stepOrder,
      title: title,
      category: category,
      summary: summary,
      requiredDocuments: requiredDocuments,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  static List<LegalStepModel> get defaults => const [
        LegalStepModel(
          id: 'leg_1',
          stepOrder: 1,
          title: 'Şirket Türü Seçimi (A.Ş. vs Ltd. Şti.)',
          category: 'Yapılanma',
          summary:
              'Girişim sermayesi yatırımı almayı planlayan girişimler için Anonim Şirket (A.Ş.) hisse devri ve vergi avantajları bakımından önerilir.',
          requiredDocuments: ['Ortaklar Kimlik Fotokopileri', 'Kira Sözleşmesi'],
          isCompleted: true,
        ),
        LegalStepModel(
          id: 'leg_2',
          stepOrder: 2,
          title: 'MERSİS Başvurusu ve Esas Sözleşme',
          category: 'Kuruluş',
          summary:
              'Merkezi Sicil Kayıt Sistemi üzerinden potansiyel vergi numarası alınır ve şirket ana sözleşmesi noter/ticaret odasında onaylatılır.',
          requiredDocuments: ['MERSİS Talep No', 'Ana Sözleşme Metni'],
          isCompleted: true,
        ),
        LegalStepModel(
          id: 'leg_3',
          stepOrder: 3,
          title: 'Vergi Dairesi Yoklaması ve E-Tebligat',
          category: 'Vergi',
          summary:
              'Şirket tescilinden sonra interaktif vergi dairesi üzerinden işe başlama bildirimi yapılır ve yoklama memuru adresi denetler.',
          requiredDocuments: ['İmza Sirküleri', 'Ticaret Sicil Gazetesi'],
          isCompleted: false,
        ),
        LegalStepModel(
          id: 'leg_4',
          stepOrder: 4,
          title: 'TÜRKPATENT Marka ve İsim Tescili',
          category: 'Fikri Mülkiyet',
          summary:
              'StartPath markanızın ve logonuzun ilgili Nice sınıflarında 10 yıllık koruma altına alınması için resmi başvuru süreci.',
          requiredDocuments: ['Marka Örneği/Logo', 'Rüçhan Belgesi (Varsa)'],
          isCompleted: false,
        ),
      ];
}
