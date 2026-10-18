import 'package:flutter/material.dart';

class LayoutStylingScreen extends StatefulWidget {
  const LayoutStylingScreen({super.key});

  @override
  State<LayoutStylingScreen>
      createState() => //işlemlerin otomatik çalışması için stat kullanırız
          _LayoutStylingScreenState();
}

class _LayoutStylingScreenState extends State<LayoutStylingScreen> {
  bool isBalanceVisible = true;
  String _lastAction = 'Hazır - Butonlara Tıklayabilirsiniz';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics:
          const BouncingScrollPhysics(), //ekranı scroll etme özelliğini aktiflşşitrme
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Profil online rozeti;
          _buildProfileHeader(),
          //cüzdan kartı
          _buildWalletCard(),
          //aksiyon butonları-sayfalar arsı geçiş
          _buildQuickActions(),
          //İstatistik Bölümü
          _buildFlexStatistics(),
          // notification bldirim banner
          _buildNotificationBanner(),

          //Canlı durum bildirimi
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Son İşlem: $_lastAction',
                style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                    fontStyle: FontStyle.italic),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0x1F6366F1),
                    border:
                        Border.all(color: const Color(0xFF6366F1), width: 2),
                  ))
            ],
          )
        ],
      ),
    );
  }

  Widget _buildWalletCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF6366F1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Toplam Bakiye',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isBalanceVisible = !isBalanceVisible;
                      _lastAction = 'Bakiye görünürlüğü değiştirildi';
                    });
                  },
                  icon: Icon(
                    isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              isBalanceVisible ? '₺ 2.450,00' : '₺ ••••••',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Güncel Cüzdan Bakiyesi',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _lastAction = 'Para Gönder butonuna tıklandı';
                  });
                },
                icon: const Icon(
                  Icons.send,
                  color: Color(0xFF6366F1),
                  size: 30,
                ),
              ),
              const Text('Para Gönder'),
            ],
          ),
          Column(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _lastAction = 'İşlemler butonuna tıklandı';
                  });
                },
                icon: const Icon(
                  Icons.history,
                  color: Color(0xFF6366F1),
                  size: 30,
                ),
              ),
              const Text('İşlemler'),
            ],
          ),
          Column(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _lastAction = 'Profil butonuna tıklandı';
                  });
                },
                icon: const Icon(
                  Icons.person,
                  color: Color(0xFF6366F1),
                  size: 30,
                ),
              ),
              const Text('Profil'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFlexStatistics() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'İstatistikler',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.trending_up,
                        color: Colors.green,
                      ),
                      SizedBox(height: 12),
                      Text('Toplam Gelir'),
                      SizedBox(height: 8),
                      Text(
                        '₺ 5.000',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.trending_down,
                        color: Colors.red,
                      ),
                      SizedBox(height: 12),
                      Text('Toplam Gider'),
                      SizedBox(height: 8),
                      Text(
                        '₺ 2.550',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFE0F2FE),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFBAE6FD),
          ),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.notifications_active,
              color: Color(0xFF0284C7),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Yeni bildirimleriniz var! Güncel işlemlerinizi kontrol edin.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF0369A1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
