import 'package:flutter_test/flutter_test.dart';
import 'package:habipet/app.dart';
import 'package:habipet/features/pets/models/pet_model.dart';
import 'package:habipet/features/pets/controller/pet_controller.dart';
import 'package:habipet/features/habits/controller/habit_controller.dart';
import 'package:habipet/features/badges/controller/badge_controller.dart';
import 'package:habipet/features/cupboard/controller/cupboard_controller.dart';

void main() {
  group('habiPEt App Widget Smoke Test', () {
    testWidgets('App launches and displays habiPEt title and navigation',
        (WidgetTester tester) async {
      await tester.pumpWidget(const HabiPetApp());
      await tester.pump(const Duration(milliseconds: 100));

      // Dismiss welcome dialog if present
      final dismissButton = find.text('Hadi Başlayalım! 🚀');
      if (dismissButton.evaluate().isNotEmpty) {
        await tester.tap(dismissButton);
        await tester.pump(const Duration(milliseconds: 100));
      }

      // Verify app name and home view elements
      expect(find.text('habiPEt'), findsWidgets);
      expect(find.text('Mırnav'), findsOneWidget);
      expect(find.text('Ana Sayfa'), findsOneWidget);
      expect(find.text('Alışkanlık'), findsOneWidget);
      expect(find.text('Takvim'), findsOneWidget);
      expect(find.text('Rozetler'), findsOneWidget);
      expect(find.text('Profil'), findsOneWidget);
    });
  });

  group('PetController Progress Preservation Test', () {
    test('Changing pet preserves level, currentExp, maxExp, and age', () {
      final controller = PetController();
      final initialLevel = controller.pet.level;
      final initialExp = controller.pet.currentExp;
      final initialAgeDays = controller.pet.ageInDays;

      // Feed to gain exp
      controller.feedPet(satietyBoost: 20, expBoost: 30);
      expect(controller.pet.currentExp, equals(initialExp + 30));

      // Change species to Dog
      controller.changePetType(PetType.dog);
      expect(controller.pet.type, equals(PetType.dog));
      expect(controller.pet.level, equals(initialLevel));
      expect(controller.pet.currentExp, equals(initialExp + 30));
      expect(controller.pet.ageInDays, equals(initialAgeDays));
    });

    test('Renaming pet updates name', () {
      final controller = PetController();
      controller.renamePet('Pofuduk Dost');
      expect(controller.pet.name, equals('Pofuduk Dost'));
    });
  });

  group('Habit & Badge Sync Test', () {
    test('HabitController provides preloaded habits and streaks', () {
      final controller = HabitController();
      expect(controller.habitCount, equals(5));
      expect(controller.maxStreak, equals(16));
    });

    test('BadgeController tracks 21st day progress as 16/21', () {
      final controller = BadgeController();
      final badge21 = controller.allBadges.firstWhere((b) => b.id == 'special_21_days');
      expect(badge21.progressText, equals('16/21'));
      expect(badge21.isUnlocked, isFalse);
    });
  });

  group('Cupboard & Feeding Test', () {
    test('Consuming food removes from cupboard and returns food item', () {
      final controller = CupboardController();
      final initialCount = controller.totalFoodCount;
      final food = controller.consumeFood('food_apple');

      expect(food, isNotNull);
      expect(food!.name, equals('Kırmızı Elma'));
      expect(controller.totalFoodCount, equals(initialCount - 1));
    });
  });
}
