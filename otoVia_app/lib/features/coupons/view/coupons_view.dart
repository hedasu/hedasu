import 'package:flutter/material.dart';
import '../controller/coupon_controller.dart';
import '../widgets/coupon_card.dart';
import '../widgets/coupon_progress_card.dart';
import '../../../core/widgets/empty_state_widget.dart';

class CouponsView extends StatelessWidget {
  const CouponsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Kuponlarım'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Kullanılabilir'),
              Tab(text: 'Kullanılmış'),
              Tab(text: 'Süresi Dolan'),
            ],
          ),
        ),
        body: ListenableBuilder(
          listenable: couponController,
          builder: (context, _) {
            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: CouponProgressCard(),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildList(couponController.validCoupons, 'Kupon Yok', 'Şu an kullanabileceğiniz aktif bir kupon bulunmuyor.'),
                      _buildList(couponController.usedCoupons, 'Kullanılmış Kupon Yok', 'Daha önce kullanılmış bir kuponunuz bulunmuyor.'),
                      _buildList(couponController.expiredCoupons, 'Süresi Dolan Kupon Yok', 'Süresi geçmiş kuponunuz bulunmuyor.'),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildList(List<dynamic> list, String emptyTitle, String emptyMsg) {
    if (list.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.confirmation_number_outlined,
        title: emptyTitle,
        message: emptyMsg,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CouponCard(coupon: list[index]),
        );
      },
    );
  }
}
