import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/main.dart';

void main() {
  testWidgets('Susadım su, egzersiz, geri alma ve rozetler modülü tam testi', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    // Uygulama başlatılır
    await tester.pumpWidget(const SusadimApp());
    await tester.pumpAndSettle();

    // 1. Su Takibi: Ekleme, Azaltma ve Geri Alma
    expect(find.text('0'), findsOneWidget);
    await tester.tap(find.text('+200 ml'));
    await tester.pumpAndSettle();
    expect(find.text('200'), findsOneWidget);

    await tester.tap(find.text('-100 ml'));
    await tester.pumpAndSettle();
    expect(find.text('100'), findsOneWidget);

    // Su sekmesindeki Geri Al butonuna tıklama
    await tester.tap(find.text('Geri Al'));
    await tester.pumpAndSettle();
    expect(find.text('200'), findsOneWidget);

    // Su hedefini tamamlama (2500 ml+)
    final add1000Btn = find.byIcon(Icons.battery_charging_full_rounded);
    await tester.tap(add1000Btn);
    await tester.pumpAndSettle();
    await tester.tap(add1000Btn);
    await tester.pumpAndSettle();
    await tester.tap(add1000Btn);
    await tester.pumpAndSettle();
    expect(find.text('ROZET KAZANILDI! 🏅'), findsOneWidget);

    // 2. Egzersiz Sekmesi: Ekleme ve Geri Alma
    await tester.tap(find.text('Egzersiz'));
    await tester.pumpAndSettle();
    expect(find.text('Hızlı Egzersiz'), findsOneWidget);

    // Koşu egzersizi ekleme
    await tester.tap(find.text('Koşu'));
    await tester.pumpAndSettle();
    expect(find.text('220'), findsOneWidget);

    // Egzersiz sekmesindeki Geri Al butonuna basma
    await tester.tap(find.text('Geri Al'));
    await tester.pumpAndSettle();
    expect(find.text('0'), findsWidgets);

    // Egzersiz hedefini tamamlama (500 kcal+)
    final weightBtn = find.widgetWithText(InkWell, 'Ağırlık');
    await tester.tap(weightBtn);
    await tester.pumpAndSettle();
    await tester.tap(weightBtn);
    await tester.pumpAndSettle();
    await tester.tap(find.text('HIIT'));
    await tester.pumpAndSettle();

    // 3. Rozetler Modülü (Yeni Sekme)
    await tester.tap(find.text('Rozetler'));
    await tester.pumpAndSettle();

    expect(find.text('Rozet Odası'), findsOneWidget);
    expect(find.text('Tüm Başarılar'), findsOneWidget);
    expect(find.text('Hidrasyon Şampiyonu'), findsOneWidget);
    expect(find.text('Kalori Canavarı'), findsOneWidget);
    expect(find.text('Çifte Şampiyon'), findsOneWidget);
  });
}
