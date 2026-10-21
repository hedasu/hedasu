import 'package:flutter_test/flutter_test.dart';
import 'package:packpilot/core/constants/app_constants.dart';
import 'package:packpilot/core/utils/date_utils.dart';
import 'package:packpilot/core/utils/luggage_calculator.dart';
import 'package:packpilot/features/packing_list/models/packing_item_model.dart';
import 'package:packpilot/features/trip_planner/models/trip_planner_model.dart';

void main() {
  group('PackPilot Core Utilities & Models Tests', () {
    test('LuggageCalculator correctly estimates weight and volume', () {
      final itemMetrics = LuggageCalculator.estimateItemMetrics('pamuklu tişört');
      expect(itemMetrics.weight, greaterThan(0.1));
      expect(itemMetrics.volume, greaterThan(0.5));

      final coatMetrics = LuggageCalculator.estimateItemMetrics('kışlık mont');
      expect(coatMetrics.weight, greaterThanOrEqualTo(1.0));
    });

    test('LuggageCalculator checks cabin luggage limits', () {
      final isOver = LuggageCalculator.isCabinExceeded(
        totalWeight: 9.5,
        totalVolume: 35.0,
      );
      expect(isOver, isTrue);

      final isSafe = LuggageCalculator.isCabinExceeded(
        totalWeight: 6.0,
        totalVolume: 25.0,
      );
      expect(isSafe, isFalse);
    });

    test('AppDateUtils calculates trip duration days correctly', () {
      final start = DateTime(2026, 6, 1);
      final end = DateTime(2026, 6, 5);
      final days = AppDateUtils.calculateDurationDays(start, end);
      expect(days, equals(5));
    });

    test('TripPlannerModel computes packed count and metrics', () {
      const item1 = PackingItemModel(
        id: '1',
        name: 'Gömlek',
        category: AppConstants.categoryClothing,
        quantity: 2,
        unitWeightKg: 0.25,
        unitVolumeLiters: 0.9,
        isPacked: true,
      );
      const item2 = PackingItemModel(
        id: '2',
        name: 'Şarj Aleti',
        category: AppConstants.categoryTech,
        quantity: 1,
        unitWeightKg: 0.15,
        unitVolumeLiters: 0.3,
        isPacked: false,
      );

      final trip = TripPlannerModel(
        id: 'test_trip',
        destination: 'İzmir',
        startDate: DateTime(2026, 7, 10),
        endDate: DateTime(2026, 7, 14),
        items: [item1, item2],
        createdAt: DateTime.now(),
      );

      expect(trip.totalItemsCount, equals(2));
      expect(trip.packedCount, equals(1));
      expect(trip.packedRatio, equals(0.5));
      expect(trip.totalWeightKg, closeTo(0.65, 0.01));
    });
  });
}
