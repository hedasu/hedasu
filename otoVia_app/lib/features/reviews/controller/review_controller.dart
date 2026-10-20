import 'package:flutter/material.dart';
import '../models/review_model.dart';

final ReviewController reviewController = ReviewController();

class ReviewController extends ChangeNotifier {
  ReviewController() {
    _initReviews();
  }

  final List<ReviewModel> _reviews = [];

  List<ReviewModel> get allReviews => List.unmodifiable(_reviews);

  List<ReviewModel> getReviewsForVehicle(String vehicleId) {
    return _reviews.where((r) => r.vehicleId == vehicleId).toList();
  }

  void _initReviews() {
    _reviews.addAll([
      ReviewModel(
        id: 'rev_01',
        vehicleId: 'veh_01',
        userName: 'Murat K.',
        rating: 5.0,
        comment: 'Porsche Taycan sürüş hissi ve konforu inanılmazdı. Teslimat çok hızlı ve profesyoneldi.',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      ReviewModel(
        id: 'rev_02',
        vehicleId: 'veh_01',
        userName: 'Selin A.',
        rating: 4.8,
        comment: 'Şehir içi ve otoyol kullanımı çok keyifli. Batarya menzili fazlasıyla yetti.',
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
      ),
      ReviewModel(
        id: 'rev_03',
        vehicleId: 'veh_02',
        userName: 'Emre T.',
        rating: 5.0,
        comment: 'S 500 gerçek bir executive deneyimi. Arka koltuk masaj ve konfor harika.',
        createdAt: DateTime.now().subtract(const Duration(days: 14)),
      ),
    ]);
  }

  void addReview({
    required String vehicleId,
    required String userName,
    required double rating,
    required String comment,
    bool specsMatched = true,
    bool purposeMatched = true,
    bool supportSatisfied = true,
  }) {
    final newReview = ReviewModel(
      id: 'rev_${DateTime.now().millisecondsSinceEpoch}',
      vehicleId: vehicleId,
      userName: userName,
      rating: rating,
      comment: comment,
      createdAt: DateTime.now(),
      specsMatched: specsMatched,
      purposeMatched: purposeMatched,
      supportSatisfied: supportSatisfied,
    );
    _reviews.insert(0, newReview);
    notifyListeners();
  }
}
