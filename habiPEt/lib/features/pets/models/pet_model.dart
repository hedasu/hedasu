import 'pet_growth_stage.dart';

enum PetType {
  cat,
  dog,
  bunny,
  fox,
  owl,
  dragon;

  String get displayName {
    switch (this) {
      case PetType.cat:
        return 'Kedi';
      case PetType.dog:
        return 'Köpek';
      case PetType.bunny:
        return 'Tavşan';
      case PetType.fox:
        return 'Tilki';
      case PetType.owl:
        return 'Baykuş';
      case PetType.dragon:
        return 'Ejderha';
    }
  }

  String get defaultName {
    switch (this) {
      case PetType.cat:
        return 'Mırnav';
      case PetType.dog:
        return 'Karabaş';
      case PetType.bunny:
        return 'Pofuduk';
      case PetType.fox:
        return 'Kızıl';
      case PetType.owl:
        return 'Bilge';
      case PetType.dragon:
        return 'Kıvılcım';
    }
  }

  String get description {
    switch (this) {
      case PetType.cat:
        return 'Uysal, meraklı ve sevimli dostun.';
      case PetType.dog:
        return 'Sadık, enerjik ve seni her zaman neşelendiren yoldaş.';
      case PetType.bunny:
        return 'Yumuşacık, sevimli ve hedeflerine hızlı zıplayan arkadaş.';
      case PetType.fox:
        return 'Zeki, kurnaz ve stratejik hedeflerde usta rehber.';
      case PetType.owl:
        return 'Bilge, sakin ve gece hedeflerinin koruyucusu.';
      case PetType.dragon:
        return 'Efsanevi, güçlü ve iradeni ateşleyen mitik koruyucu.';
    }
  }

  String get emoji {
    switch (this) {
      case PetType.cat:
        return '🐱';
      case PetType.dog:
        return '🐶';
      case PetType.bunny:
        return '🐰';
      case PetType.fox:
        return '🦊';
      case PetType.owl:
        return '🦉';
      case PetType.dragon:
        return '🐲';
    }
  }
}

class PetModel {
  final String id;
  final String name;
  final PetType type;
  final int level;
  final int currentExp;
  final int maxExp;
  final int satiety; // 0 - 100
  final DateTime appStartDate;

  const PetModel({
    required this.id,
    required this.name,
    required this.type,
    this.level = 1,
    this.currentExp = 0,
    this.maxExp = 100,
    this.satiety = 75,
    required this.appStartDate,
  });

  /// Current growth phase of the pet
  PetGrowthStage get growthStage => PetGrowthStage.fromLevel(level);

  /// Progress (0.0 - 1.0) towards advancing to the next growth phase
  double get stageProgress {
    switch (growthStage) {
      case PetGrowthStage.baby:
        return ((level - 1) / 4.0).clamp(0.0, 1.0);
      case PetGrowthStage.junior:
        return ((level - 5) / 5.0).clamp(0.0, 1.0);
      case PetGrowthStage.teen:
        return ((level - 10) / 10.0).clamp(0.0, 1.0);
      case PetGrowthStage.adult:
        return 1.0;
    }
  }

  int get levelsUntilNextStage {
    final nextLvl = growthStage.nextStageLevel;
    if (nextLvl == null) return 0;
    return (nextLvl - level).clamp(0, 999);
  }

  String get stageDescription {
    switch (growthStage) {
      case PetGrowthStage.baby:
        return 'Yavru $name dünyayı merakla keşfediyor ve seninle büyüyor!';
      case PetGrowthStage.junior:
        return 'Genç $name hedeflerine enerji ve neşeyle koşuyor!';
      case PetGrowthStage.teen:
        return 'Gelişkin $name sarsılmaz bir irade ve odaklanma sergiliyor!';
      case PetGrowthStage.adult:
        return 'Efsanevi $name alışkanlıklarının kadim ve kudretli ustası oldu!';
    }
  }

  /// Age is determined by the user's app usage duration
  int get ageInDays {
    final now = DateTime.now();
    final days = now.difference(appStartDate).inDays;
    return days < 1 ? 1 : days + 1;
  }

  String get ageFormatted {
    final days = ageInDays;
    if (days < 30) {
      return '$days Günlük';
    } else {
      final months = (days / 30).floor();
      final remDays = days % 30;
      if (remDays == 0) {
        return '$months Aylık';
      }
      return '$months Ay $remDays Günlük';
    }
  }

  double get expProgress => (currentExp / maxExp).clamp(0.0, 1.0);
  double get satietyProgress => (satiety / 100.0).clamp(0.0, 1.0);

  PetModel copyWith({
    String? id,
    String? name,
    PetType? type,
    int? level,
    int? currentExp,
    int? maxExp,
    int? satiety,
    DateTime? appStartDate,
  }) {
    return PetModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      level: level ?? this.level,
      currentExp: currentExp ?? this.currentExp,
      maxExp: maxExp ?? this.maxExp,
      satiety: satiety ?? this.satiety,
      appStartDate: appStartDate ?? this.appStartDate,
    );
  }
}
