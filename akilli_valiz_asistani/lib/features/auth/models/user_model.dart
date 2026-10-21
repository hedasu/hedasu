class UserModel {
  final String id;
  final String name;
  final String email;
  final String themePreference; // 'system', 'light', 'dark'
  final bool notificationsEnabled;
  final bool cycleTrackingEnabled;
  final DateTime? lastPeriodDate;
  final int cycleLengthDays;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    String? themePreference,
    bool isDarkMode = false,
    this.notificationsEnabled = true,
    this.cycleTrackingEnabled = false,
    this.lastPeriodDate,
    this.cycleLengthDays = 28,
  }) : themePreference = themePreference ?? (isDarkMode ? 'dark' : 'light');

  /// Geriye dönük uyumluluk için getter
  bool get isDarkMode => themePreference == 'dark';

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? themePreference,
    bool? isDarkMode,
    bool? notificationsEnabled,
    bool? cycleTrackingEnabled,
    DateTime? lastPeriodDate,
    int? cycleLengthDays,
  }) {
    String resolvedTheme = themePreference ?? this.themePreference;
    if (isDarkMode != null && themePreference == null) {
      resolvedTheme = isDarkMode ? 'dark' : 'light';
    }

    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      themePreference: resolvedTheme,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      cycleTrackingEnabled: cycleTrackingEnabled ?? this.cycleTrackingEnabled,
      lastPeriodDate: lastPeriodDate ?? this.lastPeriodDate,
      cycleLengthDays: cycleLengthDays ?? this.cycleLengthDays,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    String theme = json['themePreference'] as String? ?? '';
    if (theme.isEmpty) {
      final legacyDark = json['isDarkMode'] as bool? ?? false;
      theme = legacyDark ? 'dark' : 'light';
    }

    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      themePreference: theme,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      cycleTrackingEnabled: json['cycleTrackingEnabled'] as bool? ?? false,
      lastPeriodDate: json['lastPeriodDate'] != null
          ? DateTime.parse(json['lastPeriodDate'] as String)
          : null,
      cycleLengthDays: (json['cycleLengthDays'] as num?)?.toInt() ?? 28,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'themePreference': themePreference,
      'isDarkMode': isDarkMode,
      'notificationsEnabled': notificationsEnabled,
      'cycleTrackingEnabled': cycleTrackingEnabled,
      'lastPeriodDate': lastPeriodDate?.toIso8601String(),
      'cycleLengthDays': cycleLengthDays,
    };
  }
}
