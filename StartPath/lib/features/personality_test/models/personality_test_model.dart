/// Çalışma Tarzı ve Uyumluluk Testi Sorusu Modeli
class TestQuestionModel {
  final int id;
  final String question;
  final List<String> options;

  const TestQuestionModel({
    required this.id,
    required this.question,
    required this.options,
  });

  static List<TestQuestionModel> get defaultQuestions => const [
        TestQuestionModel(
          id: 1,
          question: 'Karar alma süreçlerinde hangi yaklaşımı tercih edersiniz?',
          options: [
            'Veriye dayalı analiz ve metrikler',
            'Sezgisel ve hızlı deneme-yanılma',
            'Ekip içi uzlaşı ve fikir birliği',
          ],
        ),
        TestQuestionModel(
          id: 2,
          question: 'Proje yönetiminde çalışma tarzınız nasıldır?',
          options: [
            'Haftalık sprint ve planlı kilometre taşları',
            'Esnek, çevik ve anlık önceliklendirme',
            'Hedef odaklı, zamandan bağımsız teslimat',
          ],
        ),
        TestQuestionModel(
          id: 3,
          question: 'Kriz veya fikir ayrılığı anlarında ilk tepkiniz ne olur?',
          options: [
            'Sorunun kök nedenini listeleyip tartışmak',
            'Alternatif bir A/B testi uygulayarak sonucu görmek',
            'Mola verip tarafsız bir mentor görüşü almak',
          ],
        ),
      ];
}
