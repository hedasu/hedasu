class ReviewModel {
  const ReviewModel({
    required this.id,
    required this.vehicleId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.specsMatched = true,
    this.purposeMatched = true,
    this.supportSatisfied = true,
  });

  final String id;
  final String vehicleId;
  final String userName;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final bool specsMatched;
  final bool purposeMatched;
  final bool supportSatisfied;
}
