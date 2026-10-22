import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../../../core/constants/app_colors.dart';

class HabitRepository {
  List<HabitModel> getPreloadedHabits() {
    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: 15));

    List<DateTime> pastDays(int count) {
      return List.generate(count, (index) {
        return now.subtract(Duration(days: index));
      });
    }

    return [
      HabitModel(
        id: 'habit_water',
        title: 'Su İçme',
        target: 'Günde 2.5 Litre (8 Bardak)',
        category: 'Sağlık',
        icon: Icons.water_drop_rounded,
        color: AppColors.habitColors[1],
        startDate: startDate,
        currentStreak: 16,
        bestStreak: 16,
        completedDates: pastDays(16),
      ),
      HabitModel(
        id: 'habit_sport',
        title: 'Spor & Antrenman',
        target: '30 Dakika Günlük Egzersiz',
        category: 'Fitness',
        icon: Icons.fitness_center_rounded,
        color: AppColors.habitColors[3],
        startDate: startDate,
        currentStreak: 14,
        bestStreak: 14,
        completedDates: pastDays(14),
      ),
      HabitModel(
        id: 'habit_yoga',
        title: 'Yoga & Meditasyon',
        target: '15 Dakika Zihinsel Farkındalık',
        category: 'Ruh & Beden',
        icon: Icons.self_improvement_rounded,
        color: AppColors.habitColors[2],
        startDate: startDate,
        currentStreak: 12,
        bestStreak: 12,
        completedDates: pastDays(12),
      ),
      HabitModel(
        id: 'habit_smoking',
        title: 'Sigara Bırakma',
        target: 'Temiz Nefes & Sıfır Duman',
        category: 'Sağlık & İrade',
        icon: Icons.smoke_free_rounded,
        color: AppColors.habitColors[0],
        startDate: startDate,
        currentStreak: 16,
        bestStreak: 16,
        completedDates: pastDays(16),
      ),
      HabitModel(
        id: 'habit_reading',
        title: 'Kitap Okuma',
        target: 'Günde 20 Sayfa',
        category: 'Kişisel Gelişim',
        icon: Icons.menu_book_rounded,
        color: AppColors.habitColors[5],
        startDate: startDate,
        currentStreak: 15,
        bestStreak: 15,
        completedDates: pastDays(15),
      ),
    ];
  }
}
