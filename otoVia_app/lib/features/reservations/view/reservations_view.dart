import 'package:flutter/material.dart';
import '../controller/reservation_controller.dart';
import '../widgets/reservation_card.dart';
import '../../../core/widgets/empty_state_widget.dart';

/// otoVia Kiralamalarım Ekranı (ReservationsView)
///
/// Kullanıcının tüm kiralama işlemlerini sekmeler (Tabs) halinde gruplar:
/// - Aktif: Şu anda kullanımda olan araçlar
/// - Gelecek: Onaylanmış ve başlama tarihi beklenen rezervasyonlar
/// - Geçmiş: Başarıyla teslim edilmiş ve tamamlanmış kiralamalar
/// - İptal Edilen: İptal edilmiş rezervasyon kayıtları
class ReservationsView extends StatelessWidget {
  const ReservationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rezervasyonlarım'),
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: 'Aktif'),
              Tab(text: 'Gelecek'),
              Tab(text: 'Geçmiş'),
              Tab(text: 'İptal Edilen'),
            ],
          ),
        ),
        body: ListenableBuilder(
          listenable: reservationController,
          builder: (context, _) {
            return TabBarView(
              children: [
                // Aktif kiralamalar sekmesi
                _buildList(context, reservationController.activeReservations, 'Aktif Kiralama Yok', 'Şu anda kullanımda olan bir aracınız bulunmuyor.'),
                // Gelecek rezervasyonlar sekmesi
                _buildList(context, reservationController.upcomingReservations, 'Gelecek Rezervasyon Yok', 'Planlanmış bir kiralamanız bulunmuyor.'),
                // Geçmiş tamamlanan kiralamalar sekmesi
                _buildList(context, reservationController.completedReservations, 'Geçmiş Kiralama Yok', 'Tamamlanmış kiralama geçmişiniz bulunmuyor.'),
                // İptal edilenler sekmesi
                _buildList(context, reservationController.cancelledReservations, 'İptal Edilen Rezervasyon Yok', 'İptal edilen herhangi bir işlem bulunmuyor.'),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Sekme içi rezervasyon listesini oluşturan yardımcı metot (boş ise EmptyStateWidget döner)
  Widget _buildList(BuildContext context, List<dynamic> list, String emptyTitle, String emptyMsg) {
    if (list.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.calendar_month_outlined,
        title: emptyTitle,
        message: emptyMsg,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ReservationCard(reservation: list[index]),
        );
      },
    );
  }
}
