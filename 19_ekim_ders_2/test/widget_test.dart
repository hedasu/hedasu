import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/core/theme/theme_controller.dart';
import 'package:susadim/features/badges/controllers/badge_controller.dart';
import 'package:susadim/features/water_tracker/controllers/water_tracker_controller.dart';
import 'package:susadim/features/workout/controllers/workout_controller.dart';
import 'package:susadim/main.dart';

void main() {
  group('ThemeController Testleri', () {
    test('Tema değiştirme (toggle) doğru çalışmalı', () {
      final themeController = ThemeController();

      expect(themeController.themeMode.value, ThemeMode.dark);
      expect(themeController.isDarkMode, isTrue);

      // Aydınlık moda geçiş
      themeController.toggleTheme();
      expect(themeController.themeMode.value, ThemeMode.light);
      expect(themeController.isDarkMode, isFalse);

      // Tekrar karanlık moda geçiş
      themeController.toggleTheme();
      expect(themeController.themeMode.value, ThemeMode.dark);
      expect(themeController.isDarkMode, isTrue);

      themeController.dispose();
    });
  });

  group('WaterTrackerController Testleri', () {
    test('Su ekleme ve geri alma (undo) mekanizması doğru çalışmalı', () {
      final badgeController = BadgeController();
      final waterController = WaterTrackerController(
        badgeController: badgeController,
        dailyGoalWater: 2000,
      );

      expect(waterController.currentWater.value, 0);
      expect(waterController.canUndo, isFalse);

      // Su ekle: 250 ml
      waterController.addWater(250, label: 'Bardak');
      expect(waterController.currentWater.value, 250);
      expect(waterController.history.value.length, 1);
      expect(waterController.canUndo, isTrue);

      // Su ekle: 500 ml
      waterController.addWater(500, label: 'Matara');
      expect(waterController.currentWater.value, 750);
      expect(waterController.history.value.length, 2);

      // Geri al: 500 ml silinmeli, 250 ml kalmalı
      final undoSuccess = waterController.undoLastWater();
      expect(undoSuccess, isTrue);
      expect(waterController.currentWater.value, 250);
      expect(waterController.history.value.length, 1);

      // Tekrar geri al: 250 ml silinmeli, 0 kalmalı
      waterController.undoLastWater();
      expect(waterController.currentWater.value, 0);
      expect(waterController.canUndo, isFalse);

      waterController.dispose();
      badgeController.dispose();
    });
  });

  group('WorkoutController Testleri', () {
    test('Egzersiz ekleme, kalori hesaplama ve geri alma çalışmalı', () {
      final badgeController = BadgeController();
      final workoutController = WorkoutController(
        badgeController: badgeController,
        dailyCalorieGoal: 500,
        dailyMinutesGoal: 40,
      );

      expect(workoutController.totalMinutes, 0);
      expect(workoutController.totalCalories, 0);

      // Antrenman ekle
      workoutController.addWorkout(
        title: 'Ağırlık',
        durationMinutes: 45,
        caloriesBurned: 320,
        category: 'strength',
      );

      expect(workoutController.totalMinutes, 45);
      expect(workoutController.totalCalories, 320);
      expect(workoutController.canUndo, isTrue);

      // İkinci antrenman ekle
      workoutController.addWorkout(
        title: 'Koşu',
        durationMinutes: 20,
        caloriesBurned: 200,
        category: 'cardio',
      );
      expect(workoutController.totalMinutes, 65);
      expect(workoutController.totalCalories, 520);

      // Geri al
      final undoSuccess = workoutController.undoLastWorkout();
      expect(undoSuccess, isTrue);
      expect(workoutController.totalMinutes, 45);
      expect(workoutController.totalCalories, 320);

      workoutController.dispose();
      badgeController.dispose();
    });
  });

  group('BadgeController Testleri', () {
    test('Su ve antrenman hedeflerinde rozetler açılmalı', () {
      final badgeController = BadgeController();

      // İlk damla rozeti kontrolü
      badgeController.checkWaterBadges(200, 2000);
      final waterFirst = badgeController.badges.value.firstWhere((b) => b.id == 'water_first');
      expect(waterFirst.isUnlocked, isTrue);

      // Su hedefi tamamlama rozeti
      badgeController.checkWaterBadges(2000, 2000);
      final waterGoal = badgeController.badges.value.firstWhere((b) => b.id == 'water_goal');
      expect(waterGoal.isUnlocked, isTrue);

      // Kalori avcısı rozeti (500 kcal)
      badgeController.checkWorkoutBadges(45, 550, 500);
      final burn500 = badgeController.badges.value.firstWhere((b) => b.id == 'workout_burn_500');
      expect(burn500.isUnlocked, isTrue);

      badgeController.dispose();
    });
  });

  group('Widget Duman (Smoke) ve Tema Geçiş Testi', () {
    testWidgets('Susadım v1 arayüzü açılmalı ve tema dinamik değişmeli', (WidgetTester tester) async {
      await tester.pumpWidget(const SusadimApp());
      await tester.pumpAndSettle();

      expect(find.text('Susadım v1'), findsOneWidget);
      expect(find.text('Su Takibi'), findsOneWidget);
      expect(find.text('Egzersiz'), findsOneWidget);
      expect(find.text('Rozetler'), findsOneWidget);
      expect(find.text('Karanlık'), findsOneWidget);

      // Tema butonuna tıkla
      await tester.tap(find.text('Karanlık'));
      await tester.pumpAndSettle();

      // Aydınlık moda geçtiğini doğrula
      expect(find.text('Aydınlık'), findsOneWidget);

      // Tekrar tıkla, karanlık moda dönsün
      await tester.tap(find.text('Aydınlık'));
      await tester.pumpAndSettle();

      expect(find.text('Karanlık'), findsOneWidget);
    });
  });
}
