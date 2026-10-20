import 'package:flutter_test/flutter_test.dart';
import 'package:startpath/core/constants/app_strings.dart';
import 'package:startpath/main.dart';

void main() {
  testWidgets('StartPath ana kabuk ve alt navigasyon yüklenme testi', (WidgetTester tester) async {
    await tester.pumpWidget(const StartPathApp());
    await tester.pumpAndSettle();

    // Uygulama başlığı ve alt sekmeler doğrulanır
    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.text(AppStrings.navHome), findsOneWidget);
    expect(find.text(AppStrings.navTeam), findsOneWidget);
    expect(find.text(AppStrings.navMentors), findsOneWidget);
    expect(find.text(AppStrings.navOpportunities), findsOneWidget);
    expect(find.text(AppStrings.navProfile), findsOneWidget);

    // Hızlı işlemler listesi doğrulanır
    expect(find.text('Hukuki Süreç Yol Haritası'), findsOneWidget);
  });
}
