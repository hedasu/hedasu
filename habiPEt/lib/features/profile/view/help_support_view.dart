import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';

class HelpSupportView extends StatelessWidget {
  const HelpSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yardım ve Destek')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const _FaqHeader(),
            const SizedBox(height: 16),
            const _FaqAccordionList(),
            const SizedBox(height: 24),
            _SupportContactCard(
              onSubmitFeedback: () {
                context.showAppSnackBar('Geri bildiriminiz için teşekkürler! 🌿');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqHeader extends StatelessWidget {
  const _FaqHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.quiz_rounded, color: AppColors.darkMint),
        SizedBox(width: 8),
        Text(
          'Sıkça Sorulan Sorular',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

class _FaqAccordionList extends StatelessWidget {
  const _FaqAccordionList();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: const [
          ExpansionTile(
            title: Text('21 Gün Kuralı nedir?', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Bilimsel araştırmalara göre insan beyninin yeni bir davranışı otomatik bir alışkanlığa dönüştürmesi ortalama 21 gün sürer. 21. güne ulaştığında beyninde yeni sinir ağları kalıcı hale gelir.',
                  style: TextStyle(fontSize: 13, height: 1.4),
                ),
              ),
            ],
          ),
          Divider(),
          ExpansionTile(
            title: Text('Evcil hayvanımı değiştirirsem seviyem kaybolur mu?', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Kesinlikle hayır! habiPEt gelişim koruma sistemine sahiptir. Seçtiğin yeni hayvan, önceki dostunun tüm seviyesini, deneyim puanını, yaşını ve doygunluğunu birebir devralır.',
                  style: TextStyle(fontSize: 13, height: 1.4),
                ),
              ),
            ],
          ),
          Divider(),
          ExpansionTile(
            title: Text('Rozetlerimi nerede harcayabilirim?', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Alışkanlıklarını tamamladıkça kazandığın rozetleri Market modülünde harcayarak evcil hayvanın için lezzetli yiyecekler satın alabilir ve onu besleyerek seviye atlatabilirsin.',
                  style: TextStyle(fontSize: 13, height: 1.4),
                ),
              ),
            ],
          ),
          Divider(),
          ExpansionTile(
            title: Text('Rozetlerin değer sıralaması nasıldır?', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Rozetler değerlerine göre sıralanır: Yıllık > Aylık > Haftalık > Günlük. Daha uzun vadeli disiplinler her zaman daha yüksek rozet ödülü ve prestij kazandırır.',
                  style: TextStyle(fontSize: 13, height: 1.4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SupportContactCard extends StatelessWidget {
  final VoidCallback onSubmitFeedback;

  const _SupportContactCard({required this.onSubmitFeedback});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bize Ulaşın / Geri Bildirim',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'Bir sorun mu yaşıyorsun veya bir önerin mi var? Ekibimizle paylaş.',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onSubmitFeedback,
                icon: const Icon(Icons.mail_outline_rounded),
                label: const Text('Geri Bildirim Gönder'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
