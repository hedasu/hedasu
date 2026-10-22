class UserModel {
  final String id;
  final String name;
  final String email;
  final DateTime joinedDate;
  final bool isGuest;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.joinedDate,
    this.isGuest = false,
  });

  int get daysSinceJoined {
    final now = DateTime.now();
    return now.difference(joinedDate).inDays + 1;
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    DateTime? joinedDate,
    bool? isGuest,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      joinedDate: joinedDate ?? this.joinedDate,
      isGuest: isGuest ?? this.isGuest,
    );
  }
}
